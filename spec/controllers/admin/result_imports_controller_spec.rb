require 'rails_helper'

describe Admin::ResultImportsController do

  let!(:no_admin_user) { create(:active_user) }
  let!(:admin_user)    { create(:active_admin) }

  let(:empty_result) do
    Results::ImportFinishedGames::Result.new(imported: [], discrepancies: [], unmatched: [])
  end

  let(:result_with_imports) do
    g = build_stubbed(:game)
    imported = Results::ImportFinishedGames::ImportedGame.new(game: g, home_goals: 1, away_goals: 0, duration: 'REGULAR')
    Results::ImportFinishedGames::Result.new(imported: [imported], discrepancies: [], unmatched: [])
  end

  describe '#new' do
    context 'as non-admin' do
      it 'forbids access' do
        login(no_admin_user)
        expect(Results::ImportFinishedGames).not_to receive(:call)
        get :new
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'as admin' do
      before { login(admin_user) }

      it 'runs the importer and renders the result page' do
        allow(Results::ImportFinishedGames).to receive(:call).and_return(empty_result)
        get :new
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
        expect(assigns(:result)).to eq empty_result
        expect(assigns(:duration)).to be_a(Numeric)
      end

      it 'does not send an email when there are no changes' do
        allow(Results::ImportFinishedGames).to receive(:call).and_return(empty_result)
        expect(ResultsMailer).not_to receive(:import_summary)
        get :new
      end

      it 'sends a summary email when there are changes' do
        mailer_double = double('mailer', deliver_now: true)
        allow(Results::ImportFinishedGames).to receive(:call).and_return(result_with_imports)
        expect(ResultsMailer).to receive(:import_summary).with(result_with_imports).and_return(mailer_double)
        get :new
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
        get :new
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
        expect(assigns(:result).discrepancies).to eq [discrepancy]
        expect(assigns(:result).unmatched).to eq [unmatched]
      end

      it 'still renders the result page when mail delivery fails' do
        mailer_double = double('mailer')
        allow(mailer_double).to receive(:deliver_now).and_raise(StandardError, 'SMTP timeout')
        allow(Results::ImportFinishedGames).to receive(:call).and_return(result_with_imports)
        allow(ResultsMailer).to receive(:import_summary).and_return(mailer_double)
        get :new
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
        expect(flash[:warning]).to be_present
      end

      it 'flashes a friendly error when the token is missing' do
        allow(Results::ImportFinishedGames).to receive(:call)
          .and_raise(Results::FootballDataClient::MissingTokenError.new('no token'))
        get :new
        expect(response).to redirect_to admin_games_path
        expect(flash[:error]).to include 'API-Token'
      end

      it 'flashes a friendly error on ApiError' do
        allow(Results::ImportFinishedGames).to receive(:call)
          .and_raise(Results::FootballDataClient::ApiError.new('500', status: 500, body: 'oops'))
        get :new
        expect(flash[:error]).to include '500'
      end

      it 'flashes an unexpected-error message on any other failure' do
        allow(Results::ImportFinishedGames).to receive(:call).and_raise(StandardError, 'boom')
        get :new
        expect(flash[:error]).to be_present
        expect(response).to redirect_to admin_games_path
      end
    end
  end

end
