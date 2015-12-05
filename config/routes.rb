Rails.application.routes.draw do
  resources :db_settings

  # get 'setup/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  # root 'db_settings#new'
  root 'team#index'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  get  'maintain_db' => 'maintain_db#index'
  post 'maintain_db/loadTeams' => 'maintain_db#loadTeams'
  post 'maintain_db/loadRosters' => 'maintain_db#loadRosters'
  post 'maintain_db/loadSchedules' => 'maintain_db#loadSchedules'
  post 'maintain_db/loadGamestats' => 'maintain_db#loadGamestats'
  post 'maintain_db/updateDb' => 'maintain_db#updateDb'

  get 'teams' => 'team#index'
  get 'team/:id' => 'team#show'
  get 'team/abbr/:t_abbr' => 'team#by_team'
  get 'team/schedule/:id' => 'team#schedule'

  # get 'game/:t_abbr/:boxscore_id' => 'game#show_team'
  get 'game/:boxscore_id' => 'game#show'

  get 'players' => 'player#index'
  get 'player/:id' => 'player#show'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
