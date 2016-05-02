# -*- encoding : utf-8 -*-
Tippspiel::Application.routes.draw do

  devise_scope :user do
    get '/login'  => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  namespace :admin do
    resources :games, except: [:show, :create, :new]
    resource :start_calculating, only: :new
  end

  # Eigener Controller noetig, damit eigene Attribute den strong_params von devise bekannt gemacht werden koennen
  devise_for :users, :controllers => { :registrations => 'registrations' }

  get 'tips' => 'tips#index'
  post 'save-tips' => 'tips#save_tips'
  post 'save-champion-tip' => 'tips#save_champion_tip'
  get 'ranking' => 'ranking#index'
  get 'notes' => 'notes#index'
  post 'save-notice' => 'notes#create'
  get 'help' => 'help#index'

  get '/user/edit_password'
  post '/user/change_password'

  get 'user/ranking-per-game' => 'ranking_per_game#show'


  match 'compare-tips/(:game_id)' => 'compare_tips#show', :as => 'compare_tips', :via => [:get, :post]
  get 'hall-of-fame' => 'hall_of_fames#show'

  get 'main/error' => 'main#error', :as => :error

  root :to => 'main#index'

end
