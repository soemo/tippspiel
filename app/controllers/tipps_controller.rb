# -*- encoding : utf-8 -*-
class TippsController < ApplicationController

  def index
    @user_tipps = Tipp.user_tipps(current_user.id)
  end

  def compare
    @posible_games   = Game.games_for_compare(Time.now).all
    @game_to_compare = nil
    @tipps           = nil
    if params[:id].present? && @posible_games.present? && @posible_games.map(&:id).include?(params[:id].to_i)
      @game_to_compare = @posible_games.select {|g| g.id == params[:id].to_i}.first
    elsif @posible_games.present?
      @game_to_compare = @posible_games.last
    end #no else
    if @game_to_compare.present?
      @tipps = @game_to_compare.
              tipps.
              includes("user").
              where("users.deleted_at" => nil).
              order("tipps.tipp_punkte desc").
              order("users.firstname")
    end
  end

  def save_tipps
    new_tipps = params[:tipps]
    if new_tipps.present?
      current_user_id = current_user.id
      user_tipps = Tipp.user_tipps(current_user_id)
      user_tipps.each do |tipp|
        if (new_tipps["#{tipp.id}"].present? && can?(:update, tipp)) && tipp.edit_allowed?
          tipp.team1_goals = new_tipps["#{tipp.id}"]["team1_goals"]
          tipp.team2_goals = new_tipps["#{tipp.id}"]["team2_goals"]
          tipp.remove_leading_zero
          tipp.save
        end
      end
    end
    redirect_to({:action => "index"}, {:notice => t("succesfully_saved_tipps")})
  end

  def save_champion_tipp
    respond_to do |format|
      if params[:champion_team_id].present?
        current_user.championtipp_team_id = params[:champion_team_id]
        if current_user.save
          flash[:notice] = t(:succesfully_saved_championtipp)
          format.html { redirect_to :action => "index" }
        end # no else
      else
        format.html { redirect_to :action => "index" }
      end
    end
  end

end
