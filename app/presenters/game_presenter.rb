class GamePresenter < DelegateClass(Game)

  attr_reader :game

  def initialize(game)
    super(game)
    @game = game
  end

  # used with mixitup
  def filter_categories_css_classes
    css_classes = ['mix']
    css_classes << "category-#{FILTER_TODAY}" if @game.today?
    css_classes << "category-#{FILTER_FUTURE}" if !@game.started?

    css_classes.join(' ')
  end

  def formatted_start_at
    I18n.l(@game.start_at, format: :default)
  end

  def formatted_start_at_short
    I18n.l(@game.start_at, format: :short)
  end

  def round_or_group_name
    @game.round == GROUP ? "#{I18n.t('round.group')} #{@game.group}" : I18n.t(@game.round, scope: 'round')
  end

  def result
    "#{@game.team1_goals} : #{@game.team2_goals}"
  end

  def team1_with_flag(flag_size: 32, flag_position: 'right')
    if @game.team1_id.present?
      team1_presenter = team_presenter(@game.team1)
      team1_presenter.team_name_with_flag(flag_size: flag_size,
                                          flag_position: flag_position)
    else
      @game.team1_placeholder_name
    end
  end

  def team2_with_flag(flag_size: 32, flag_position: 'left')
    if @game.team2_id.present?
      team2_presenter = team_presenter(@game.team2)
      team2_presenter.team_name_with_flag(flag_size: flag_size,
                                          flag_position: flag_position)
    else
      @game.team2_placeholder_name
    end
  end


  def team_names_with_flags(flag_size: 32, team1_flag_position: 'right', team2_flag_position: 'left')
    team1_name_with_flag = team1_with_flag(flag_size: flag_size, flag_position: team1_flag_position)
    team2_name_with_flag = team2_with_flag(flag_size: flag_size, flag_position: team2_flag_position)
    "#{team1_name_with_flag} - #{team2_name_with_flag}"
  end

  def team_names_without_flags
    if @game.team1_id.present?
      team1_name = @game.team1.name
    else
      team1_name = @game.team1_placeholder_name
    end

    if @game.team2_id.present?
      team2_name = @game.team2.name
    else
      team2_name = @game.team2_placeholder_name
    end

    "#{team1_name} - #{team2_name}"
  end

  def teams_ordered_by_name
    TeamQueries.all_ordered_by_name
  end

  private

  def team_presenter(team)
    ::TeamPresenter.new(team)
  end
end