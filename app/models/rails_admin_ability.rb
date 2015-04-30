# -*- encoding : utf-8 -*-
# https://github.com/sferik/rails_admin/wiki/CanCan
class RailsAdminAbility
  include CanCan::Ability
  def initialize(user)
    if user && user.admin?
      can :access, :rails_admin
      can :manage, :all
    end
  end
  # TODO soeren 30.04.15 brauche ich noch den RailsAdmin???
end