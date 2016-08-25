# -*- encoding : utf-8 -*-
Tippspiel::Application.routes.draw do

  devise_scope :user do
    get '/logout' => 'devise/sessions#destroy'
  end

  devise_for :users,
             controllers: {
                 registrations: 'adapted_devise/registrations' }

  authenticated :user do
    root to: 'main#index', as: 'root'
  end
  unauthenticated do
    as :user do
      root to: 'devise/sessions#new', as: 'unauthenticated_root'
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :admin do
    resources :games, except: [:show, :create, :new]
    resource :start_calculating, only: :new
  end

  # FIXME soeren 8/25/16 die 2 als recources umschreiben
  post 'save-tips' => 'tips#save_tips'
  post 'save-champion-tip' => 'tips#save_champion_tip'

  get 'ranking' => 'ranking#index'
  get 'notes' => 'notes#index'
  post 'save-notice' => 'notes#create' # FIXME soeren 8/25/16 als recources
  get 'help' => 'help#index'  # FIXME soeren 8/25/16 resource :help, only: :show

  get 'user/ranking-per-game' => 'ranking_per_game#show'
  get 'user/hall-of-fame' => 'hall_of_fames#show'

  match 'comparetips/(:game_id)' => 'compare_tips#show', :as => 'compare_tips', :via => [:get, :post]

  get 'main/error' => 'main#error', :as => :error
end
