Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'curriculum#index'

  get 'login' => 'login#index'
  post 'login/login_app' => 'login#login_app'
  get 'login/login_app' => 'login#login_app'
  get 'logout' => 'login#logout'

  get 'curriculum' => 'curriculum#list_cmds'
  get 'create_pdf' => 'curriculum#create_pdf'
  post 'clear_curriculum' => 'curriculum#clear_curriculum'
  post 'create_scope' => 'curriculum#create_scope'
  get 'create_scope' => 'curriculum#create_scope'
  get 'remove_identity' => 'curriculum#remove_identity'
  get 'remove_picture' => 'curriculum#remove_picture'
  get 'remove_scope' => 'curriculum#remove_scope'
  get 'remove_computerskill' => 'curriculum#remove_computerskill'
  post 'curr_add_all_computerskill' => 'curriculum#curr_add_all_computerskill'
  post 'curr_add_computer_skill' => 'curriculum#curr_add_computer_skill'
  post 'curr_set_identity' => 'curriculum#curr_set_identity'
  post 'curr_add_picture' => 'curriculum#curr_add_picture'

  post 'curr_add_all_education' => 'curriculum#curr_add_all_education'
  post 'curr_add_education' => 'curriculum#curr_add_education'
  get 'remove_education' => 'curriculum#remove_education'
  
  post 'curr_add_all_workexperience' => 'curriculum#curr_add_all_workexperience'
  post 'curr_add_workexperience' => 'curriculum#curr_add_workexperience'
  get 'remove_workexperience' => 'curriculum#remove_workexperience'

  post 'curr_add_all_languageskill' => 'curriculum#curr_add_all_languageskill'
  post 'curr_add_languageskill' => 'curriculum#curr_add_languageskill'
  get 'remove_languageskill' => 'curriculum#remove_languageskill'
  

  get 'load_curr' => 'load_curr#load_curr'
  get 'delete_curr' => 'load_curr#delete_curr'
  post 'reload_curr' => 'load_curr#reload_curr'

  get 'save_curr' => 'save_curr#save_curr'

  get 'picture' => 'identpictures#picture'

  #get 'options' => 'options#index'
  #post 'options' => 'options#create'

  resources :identities
  resources :identpictures
  resources :languages
  resources :options
  resources :computerskills
  resources :educations
  resources :workexperiences
  resources :languageskills


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
