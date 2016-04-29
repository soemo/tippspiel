class TipsComparePresenter

  attr_reader :possible_games
  attr_reader :game_to_compare
  attr_reader :tips

  def initialize(possible_games, game_to_compare, tips)
    @possible_games  = possible_games
    @game_to_compare = game_to_compare
    @tips           = tips
  end

  def game_to_compare_presenter
     GamePresenter.new(@game_to_compare)
  end

  def allowed_to_show?(tip)
    !tip.edit_allowed?
  end

end