require 'rails_helper'

describe Admin::GamesController do

  let!(:no_admin_user) { create(:active_user) }
  let!(:admin_user) { create(:active_admin) }

  describe '#index' do

    context 'if current_user is an admin' do

      before :each do
        login(admin_user)
      end

      it 'creates GamesPresenter and renders index' do
        get :index

        expect(response).to have_http_status(:success)
        expect(response).to render_template :index
        expect(assigns(:presenter)).to be_instance_of GamesPresenter
        expect(assigns(:presenter).current_user).to eq admin_user
      end
    end

    context 'if current_user is not an admin' do

      before :each do
        login(no_admin_user)
      end

      it 'does not create GamesPresenter and returns forbidden' do

        get :index

        expect(response).to have_http_status(:forbidden)
        expect(assigns(:presenter)).not_to be_present
      end
    end
  end

  describe '#edit' do

    context 'if current_user is an admin' do

      before :each do
        login(admin_user)
      end

      it 'creates GamePresenter and renders edit' do
        game = Game.new(id:100)
        expect(Game).to receive(:find).with(game.id.to_s).and_return(game)
        get :edit, params: { id: game.id }

        expect(response).to have_http_status(:success)
        expect(response).to render_template :edit
        expect(assigns(:presenter)).to be_instance_of GamePresenter
        expect(assigns(:presenter).game).to eq game
      end
    end

    context 'if current_user is not an admin' do

      before :each do
        login(no_admin_user)
      end

      it 'does not create GamesPresenter and returns forbidden' do
        get :edit, params: { id: 1 }

        expect(response).to have_http_status(:forbidden)
        expect(assigns(:presenter)).not_to be_present
      end
    end
  end

  describe '#update' do

    let!(:game) { create :game }

    context 'if current_user is an admin' do

      before :each do
        login(admin_user)
      end

      context 'if game_params correct' do

        it 'updates game and redirects to admin_game_path' do
          expect(game.team1_goals).to eq (0)

          get :update, params: { id: game.id, game: {team1_goals: 2} }

          expect(flash[:notice]).to eq(I18n.t(:update_successful, object_name: Game.model_name.human))
          expect(response).to redirect_to admin_games_path
          expect(Game.find(game.id).team1_goals).to eq(2)
        end
      end

      context 'if game_params incorrect' do

        it 'does not update game if no game_params' do
          expect{
            get :update, params: { id: game.id }
          }.to raise_error(ActionController::ParameterMissing)
        end

        it 'does not update game if game params not valid' do
          expect(game.team1_placeholder_name).to eq (nil)
          old_team_id = game.team1_id
          expect(old_team_id).to be_present

          get :update, params: { id: game.id, game: {team1_id: nil} }

          expect(flash[:notice]).not_to be_present
          expect(response).to render_template :edit
          presenter = assigns(:presenter)
          expect(presenter).to be_instance_of GamePresenter
          expect(presenter.game).to eq game
          expect(presenter.game.valid?).to be false
        end
      end
    end

    context 'if current_user is not an admin' do

      before :each do
        login(no_admin_user)
      end

      it 'returns forbidden' do
        get :update, params: { id: 1, game: {} }

        expect(response).to have_http_status(:forbidden)
        expect(assigns(:presenter)).not_to be_present
      end
    end
  end



end