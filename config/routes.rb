# -*- encoding : utf-8 -*-
Tippspiel::Application.routes.draw do

  devise_scope :user do
    get '/login'  => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # Eigener Controller noetig, damit eigene Attribute den strong_params von devise bekannt gemacht werden koennen
  devise_for :users, :controllers => { :registrations => 'registrations' }

  get 'scheduler/hourly'
  get 'scheduler/admin'

  get 'tipps' => 'tipps#index'
  post 'save-tipps' => 'tipps#save_tipps'
  post 'save-champion-tipp' => 'tipps#save_champion_tipp'
  get 'ranking' => 'ranking#index'
  get 'notes' => 'notes#index'
  post 'save-notice' => 'notes#create'
  get 'help' => 'help#index'

  get '/user/edit_password'
  post '/user/change_password'

  match 'compare-tips/(:game_id)' => 'compare_tips#show', :as => 'compare_tips', :via => [:get, :post]
  get 'hall-of-fame' => 'hall_of_fames#show'

  get 'main/error' => 'main#error', :as => :error

  root :to => 'main#index'

end
