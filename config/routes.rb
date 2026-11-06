Rails.application.routes.draw do
  root "trails#index"

  get "about", to: "pages#about"
  resources :regions, only: %i[index show]
  resources :parks, only: %i[index show]
  resources :trails, only: %i[index show]
  resources :tags, only: %i[index show]
  resources :activities, only: %i[index show]
  get "up" => "rails/health#show", as: :rails_health_check
end
