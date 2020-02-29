Rails.application.routes.draw do
  devise_for :users
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Catch all routes for the Vue SPA
  get "/", to: "application#catch_all"
  match "*path", to: "application#catch_all", via: :all
end
