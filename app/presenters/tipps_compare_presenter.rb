class TippsComparePresenter

  attr_reader :possible_games
  attr_reader :game_to_compare
  attr_reader :tipps

  def initialize(possible_games, game_to_compare, tipps)
    @possible_games  = possible_games
    @game_to_compare = game_to_compare
    @tipps           = tipps
  end


  def allowed_to_show?(tipp)
    !tipp.edit_allowed?
  end

end