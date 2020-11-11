Rails.application.routes.draw do
  root to: 'application#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users, only: :show
  resources :books
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
