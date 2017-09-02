Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      get "/login", to: "login#create"
      get "/login_callback", to: "users#create"

      resources :tracks, only: [:index]
      get "/tracks/top", to: "tracks#top"

      resources :artists, only: [:index]
      get "/artists/top", to: "artists#top"

      resources :genres, only: [:index]

    end
  end


end
