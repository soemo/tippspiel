class TippsComparePresenter

  attr_reader :posssible_games
  attr_reader :game_to_compare
  attr_reader :tipps

  def initialize(posssible_games, game_to_compare, tipps)
    @posssible_games = posssible_games
    @game_to_compare = game_to_compare
    @tipps           = tipps
  end


  def allowed_to_show?(tipp)
    !tipp.edit_allowed?
  end

end