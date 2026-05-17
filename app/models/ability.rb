# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here
    # See the wiki for details: https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    can :access, :main
    can :access, :help

    return if user.blank?

    can :manage, Tip, user_id: user.id

    return unless user.admin?

    can :manage, Game
  end
end
