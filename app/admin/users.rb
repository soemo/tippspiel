# -*- encoding : utf-8 -*-
ActiveAdmin.register User do
  scope :all, :default => true
  scope :inaktiv do |games|
    games.where('confirmation_token is not null')
  end
end
