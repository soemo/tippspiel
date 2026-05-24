# frozen_string_literal: true

require 'rails_helper'

describe Admin::ResultImportsController do
  let!(:no_admin_user) { create(:active_user) }
  let!(:admin_user)    { create(:active_admin) }

  let(:empty_result) do
    Results::ImportFinishedGames::Result.new(imported: [], discrepancies: [], unmatched: [])
  end

  let(:result_with_imports) do
    g = build_stubbed(:game)
    imported = Results::ImportFinishedGames::ImportedGame.new(game: g, home_goals: 1, away_goals: 0,
                                                              duration: 'REGULAR')
    Results::ImportFinishedGames::Result.new(imported: [imported], discrepancies: [], unmatched: [])
  end

  describe '#create' do
    render_views

    # The full layout renders stylesheet_link_tag / javascript_include_tag,
    # which raise "String can't be coerced into Integer" in the CI asset
    # pipeline (pre-existing environment issue unrelated to this PR).
    # Stub them at the helper module level so render_views works in CI.
    before do
      allow_any_instance_of(ActionView::Base).to receive(:stylesheet_link_tag).and_return(''.html_safe)
      allow_any_instance_of(ActionView::Base).to receive(:javascript_include_tag).and_return(''.html_safe)
    end

    context 'as non-admin' do
      it 'forbids access' do
        login(no_admin_user)
        expect(Results::ImportFinishedGames).not_to receive(:call)
        post :create
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'as admin' do
      before { login(admin_user) }

      it 'runs the importer and renders the result page' do
        allow(Results::ImportFinishedGames).to receive(:call).and_return(empty_result)
        post :create
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:create)
        expect(assigns(:result)).to eq empty_result
        expect(assigns(:duration)).to be_a(Numeric)
      end

      it 'does not send an email when there are no changes' do
        allow(Results::ImportFinishedGames).to receive(:call).and_return(empty_result)
        expect(ResultsMailer).not_to receive(:import_summary)
        post :create
      end

      it 'sends a summary email when there are changes' do
        mailer_double = double('mailer', deliver_now: true)
        allow(Results::ImportFinishedGames).to receive(:call).and_return(result_with_imports)
        expect(ResultsMailer).to receive(:import_summary).with(result_with_imports).and_return(mailer_double)
        post :create
      end

      it 'renders discrepancies and unmatched sections without error' do
        g = build_stubbed(:game)
        discrepancy = Results::ImportFinishedGames::Discrepancy.new(
          game: g, db_score: [1, 0], fd_score: [2, 0], fd_status: 'FINISHED', duration: 'REGULAR'
        )
        fd_match = Results::FootballDataAdapter::Match.new(
          fd_id: 999, home_tla: 'GER', away_tla: 'FRA',
          utc_date: Time.zone.now, status: 'FINISHED',
          home_goals: 3, away_goals: 1, duration: 'REGULAR'
        )
        unmatched = Results::ImportFinishedGames::Unmatched.new(fd_match: fd_match, reason: :no_match)
        result = Results::ImportFinishedGames::Result.new(
          imported: [], discrepancies: [discrepancy], unmatched: [unmatched]
        )
        allow(Results::ImportFinishedGames).to receive(:call).and_return(result)
        allow(ResultsMailer).to receive(:import_summary).and_return(double(deliver_now: true))
        post :create
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:create)
        expect(response.body).to include('1:0')  # db_score
        expect(response.body).to include('2:0')  # fd_score
        expect(response.body).to include('GER')  # unmatched tla
      end

      it 'still renders the result page when mail delivery fails' do
        mailer_double = double('mailer')
        allow(mailer_double).to receive(:deliver_now).and_raise(StandardError, 'SMTP timeout')
        allow(Results::ImportFinishedGames).to receive(:call).and_return(result_with_imports)
        allow(ResultsMailer).to receive(:import_summary).and_return(mailer_double)
        post :create
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:create)
        expect(flash[:warning]).to be_present
      end

      it 'flashes a friendly error when the token is missing' do
        allow(Results::ImportFinishedGames).to receive(:call)
          .and_raise(Results::FootballDataClient::MissingTokenError.new('no token'))
        post :create
        expect(response).to redirect_to admin_games_path
        expect(flash[:error]).to include 'API-Token'
      end

      it 'flashes a friendly error on ApiError' do
        allow(Results::ImportFinishedGames).to receive(:call)
          .and_raise(Results::FootballDataClient::ApiError.new('500', status: 500, body: 'oops'))
        post :create
        expect(flash[:error]).to include '500'
      end

      it 'flashes an unexpected-error message on any other failure' do
        allow(Results::ImportFinishedGames).to receive(:call).and_raise(StandardError, 'boom')
        post :create
        expect(flash[:error]).to be_present
        expect(response).to redirect_to admin_games_path
      end

      # ---- Point calculation after game finishes ----
      #
      # The controller delegates everything to Results::ImportFinishedGames.
      # When at least one game transitions to finished=true the service runs
      # the full ranking pipeline (Tips::UpdatePoints → Users::UpdatePoints →
      # Users::UpdateRankingPerGame) inside a single transaction.
      # These tests verify that the controller correctly triggers the service
      # and that the ranking services are called exactly once per import run.

      it 'triggers point recalculation when a game is newly finished' do
        allow(Results::ImportFinishedGames).to receive(:call).and_call_original
        allow(Tips::UpdatePoints).to receive(:call)
        allow(Users::UpdatePoints).to receive(:call)
        allow(Users::UpdateRankingPerGame).to receive(:call)

        ger = create(:team, name: 'Germany', football_data_tla: 'GER')
        bra = create(:team, name: 'Brazil',  football_data_tla: 'BRA')
        create(:game,
               team1: ger, team2: bra,
               start_at: 2.hours.ago,
               finished: false, team1_goals: 0, team2_goals: 0,
               football_data_match_id: 42_001)

        fake_client = double('client')
        allow(fake_client).to receive(:fetch_competition_matches).and_return({
                                                                               'matches' => [{
                                                                                 'id' => 42_001,
                                                                                 'utcDate' => 2.hours.ago.iso8601,
                                                                                 'status' => 'FINISHED',
                                                                                 'homeTeam' => { 'tla' => 'GER' },
                                                                                 'awayTeam' => { 'tla' => 'BRA' },
                                                                                 'score' => { 'duration' => 'REGULAR', 'fullTime' => { 'home' => 2, 'away' => 1 } }
                                                                               }]
                                                                             })
        allow(Results::FootballDataClient).to receive(:new).and_return(fake_client)
        allow(ResultsMailer).to receive(:import_summary).and_return(double(deliver_now: true))

        post :create

        expect(assigns(:result).imported.size).to eq 1
        expect(assigns(:result).imported.first.game.finished?).to be true
        expect(Tips::UpdatePoints).to have_received(:call).once
        expect(Users::UpdatePoints).to have_received(:call).once
        expect(Users::UpdateRankingPerGame).to have_received(:call).once
      end

      it 'does not trigger point recalculation when no game was newly finished' do
        allow(Tips::UpdatePoints).to receive(:call)
        allow(Users::UpdatePoints).to receive(:call)
        allow(Users::UpdateRankingPerGame).to receive(:call)

        allow(Results::ImportFinishedGames).to receive(:call).and_return(empty_result)

        post :create

        expect(Tips::UpdatePoints).not_to have_received(:call)
        expect(Users::UpdatePoints).not_to have_received(:call)
        expect(Users::UpdateRankingPerGame).not_to have_received(:call)
      end
    end
  end
end
