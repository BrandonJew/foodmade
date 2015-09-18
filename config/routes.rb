Rails.application.routes.draw do
  get 'reservations/new'

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'recipients/new'

  get 'sessions/new'

  root 'static_pages#home'
  get  'dashboard' => 'static_pages#dashboard'
  get 'newsletter' => 'recipients#new'
  get 'signup' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  post "reservations/:id" => "reservations#hook"
  post "hook" => "reservations#hook"
  resources :users
  resources :recipients
  resources :reservations, only: [:create, :destroy, :edit]
  resources :meetings, only: [:create, :destroy, :edit]
  resources :meetings do
    member do
      get 'destroy'
      put 'destroy'
    end
  end
  match "meetings/:id/destroy" => "meetings#destroy", :via => [:get], :as => 'meetings_destroy'
  resources :items, only: [:create, :destroy, :edit]
  resources :items do
    member do
      get 'destroy'
      put 'destroy'
    end
  end
  match "items/:id/destroy" => "items#destroy", :via => [:get], :as => 'items_destroy'
  resources :reservations do
    member do
      get 'confirm_reservation'
      put 'confirm_reservation'
      get 'deny_reservation'
      put 'deny_reservation'
    end
  end
  match "reservations/:id/confirm_reservation" => "reservations#confirm_reservation", :via => [:get], :as => 'reservations_confirm_reservation'
  match "reservations/:id/deny_reservation" => "reservations#deny_reservation", :via => [:get], :as => 'reservations_deny_reservation'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :users do
    member do
      get 'chefStatus'
      put 'chefStatus'
      get 'activationStatus'
      put 'activationStatus'
      get 'sendmessage'
      put 'sendmessage'
      get 'chefrequest'
      put 'chefrequest'
    end
  end
match "users/:id/chefStatus" => "users#chefStatus", :via => [:get], :as => 'users_chefStatus'
match "users/:id/activationStatus" => "users#activationStatus", :via => [:get], :as => 'users_activationStatus'

match "users/sendmessage" => "users#sendmessage", :via => [:get]
match "chefrequest" => "users#chefrequest", :via => [:get]


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
   #root 'application#hello'
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
