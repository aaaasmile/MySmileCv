Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'curriculum#index'

  get 'login' => 'login#index'
  post 'login/login_app' => 'login#login_app'
  get 'login/login_app' => 'login#login_app'

  get 'curriculum' => 'curriculum#list_cmds'
  post 'curr_set_identity' => 'curriculum#curr_set_identity'

  get 'load_curr' => 'load_curr#load_curr'
  get 'delete_curr' => 'load_curr#delete_curr'
  get 'logout' => 'login#logout'

  resources :identities


  #resources :Loadcurr, controller: 'load_curr'

  # Example of regular route:
  #get 'curriculum' => 'curriculum#view'

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
