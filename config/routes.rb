Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
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

  resource :champion_tips, only: [:update]
  resource :hall_of_fame, only: :show
  resource :help, only: :show
  resource :imprint, only: :show
  resources :rankings, only: :index
  resources :statistics, only: :show
  resources :tips, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      post :save_tips
    end
  end

  get 'notes' => 'notes#index'   # todo soeren 8/25/16 als recources
  post 'save-notice' => 'notes#create' # todo soeren 8/25/16 als recources

  # todo soeren 8/25/16 als recources
  match 'comparetips/(:game_id)' => 'compare_tips#show', :as => 'compare_tips', :via => [:get, :post]

  # This route must be the last route in this file.
  # It's used when no other routes matches and calls RoutingErrorsController#show with param unknown_route where the
  # specified path is stored.
  # Read comment in RoutingErrorsController#show why we use this workaround.
  match '*unknown_route', to: 'routing_errors#show', via: :all
end
