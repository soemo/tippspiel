module Admin
  class GamesController < ApplicationController

    # # FIXME soeren 4/25/16 specs
    def index
    end

    def edit

    end

    def update

    end

  end
end


#begin
# FIXME soeren 4/25/16 implement
# start_calculating
Tips::UpdatePoints.call
Users::UpdatePoints.call
Users::UpdateRankingPerGame.call
#end
