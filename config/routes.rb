Rails.application.routes.draw do
  root to: 'application#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users do
    member do
      get :followings, :followers
    end
  end

  resources :reports do
    resources :comments, only: %i[destroy create]
  end

  resources :books do
    resources :comments, only: %i[destroy create]
  end

  resources :relationships, only: %i[create destroy]
  resources :users, only: :show
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
