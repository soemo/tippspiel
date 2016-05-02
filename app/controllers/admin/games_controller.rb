module Admin
  class GamesController < Admin::BaseController

    def index
      @presenter = GamesPresenter.new(current_user)
    end

    def edit
      game = Game.find(params[:id])
      @presenter = GamePresenter.new(game)
    end

    def update
      game = ::Game.find(params[:id])

      if game.update_attributes(game_params)
        redirect_to admin_games_path, notice: t(:update_successful, object_name: Game.model_name.human)
      else
        @presenter = GamePresenter.new(game)
        render action: :edit
      end
    end

    private

    def game_params
      if current_user.admin?
        params.require(:game).permit(:lock_version, :team1_id, :team2_id,
                                     :team1_placeholder_name, :team2_placeholder_name,
                                     :team1_goals, :team2_goals, :finished, :start_at,
                                     :round, :group, :place )
      end
    end
  end
end

