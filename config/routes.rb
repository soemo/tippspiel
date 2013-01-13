# -*- encoding : utf-8 -*-
Tippspiel::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  get 'scheduler/hourly'
  get 'scheduler/admin'

  get "tipps" => "tipps#index"
  post "save-tipps" => "tipps#save_tipps"
  post "save-champion-tipp" => "tipps#save_champion_tipp"
  get "ranking" => "ranking#index"
  get "notice" => "notice#index"
  post "save-notice" => "notice#create"
  get "help" => "help#index"

  match "tipps/compare(/:id)" => "tipps#compare", :as => "compare_tipps"
  match "ranking/hall-of-fame" => "ranking#hall_of_fame", :as => "hall_of_fame"
  match "ranking/user-statistic(/:id)" => "ranking#user_statistic", :as => "user_statistic"

  match "main/error" => "main#error", :as => :error

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end



  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "main#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
