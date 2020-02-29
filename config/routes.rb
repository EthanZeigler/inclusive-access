Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  match "*path", to: "application#catch_all", via: :all
end
