Rails.application.routes.draw do
  resources :lists do
    resources :items do
      resources :votes
    end
  end
  resources :users
  resources :invitations, controller: 'rails_jwt_auth/invitations', only: [:create, :update]
  resource :password, controller: 'rails_jwt_auth/passwords', only: [:create, :update]
  resource :confirmation, controller: 'rails_jwt_auth/confirmations', only: [:create, :update]
  resource :registration, controller: 'rails_jwt_auth/registrations', only: [:create, :update, :destroy]
  # resource :registration, controller: 'registrations', only: [:create, :update, :destroy]
  resource :session, controller: 'rails_jwt_auth/sessions', only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
