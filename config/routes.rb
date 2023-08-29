Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get '/microposts', to: 'static_pages#home'
  root "static_pages#home"
  get  "/help", to: "static_pages#help"
  get  "/about", to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"
  get  "/signup", to: "users#new"
  resources :users do
    resources :followings, only: :index
    resources :followers, only: :index
  end
  resources :account_activation, only: :edit
  resources :password_resets, only: %i(new create edit update)
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: %i(create destroy)
end
