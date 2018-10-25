Nfy::Application.routes.draw do
  get '/_alive.txt', to: proc { [200, {}, ['alive']] }

  get 'sitemap.xml' => 'home#sitemap', format: :xml, as: :sitemap

  resources :lists

  resources :categories

  devise_for :users, path: '', path_names:
  {
    sign_in: 'login',
    sign_out: 'logout',
    sign_up: 'register'
  }

  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
    delete 'users/:id' => 'devise/registrations#destroy', :as => 'destroy_user_registration'
  end

  resources :note do
    patch 'copy', on: :collection
  end

  resources :onboarding, only: [:update]
  resources :support, only: %i[index create]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get '/dashboard' => 'dashboard#index'

  get '/user' => 'user#index'

  get '/tos' => 'public#tos'
  get '/privacy-policy' => 'public#privacy_policy'

  get '/bot' => 'public#bot'

  authenticate :user, ->(u) { u.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/invitation_request', to: 'invitation_requests#create'
  post '/invitation_request', to: 'invitation_requests#update', as: 'invitation_requests'

  get '/public', to: 'public_notes#index', as: :public_notes

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
