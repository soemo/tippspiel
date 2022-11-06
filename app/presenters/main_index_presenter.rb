class MainIndexPresenter

  attr_reader :tips
  attr_reader :current_user

  def initialize(tips, current_user)
    @tips = tips
    @current_user = current_user
  end

  def tip_presenters
    tips.map { |tip| TipPresenter.new(tip) }
  end

  def tournament_finished?
    Tournament.finished?
  end

  def tournament_started?
    Tournament.started?
  end

  def user_name
    current_user.name
  end

end