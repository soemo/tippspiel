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
  get 'notice' => 'notice#index'
  post 'save-notice' => 'notice#create'
  get 'help' => 'help#index'

  get '/user/preferences'
  post '/user/save_preferences'
  get '/user/edit_password'
  post '/user/change_password'
  
  match 'tipps/compare(/:id)' => 'tipps#compare', :as => 'compare_tipps', :via => [:get, :post]
  get 'ranking/hall-of-fame' => 'ranking#hall_of_fame', :as => 'hall_of_fame'

  get 'main/error' => 'main#error', :as => :error

  root :to => 'main#index'

end
