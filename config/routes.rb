Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do


      get "/login", to: "auth#spotify_request"
      get "/auth", to: "auth#show"

      resources :users, only: [:create]

      resources :tracks, only: [:index]
      get "/tracks/top", to: "tracks#top"

      resources :artists, only: [:index]
      get "/artists/top", to: "artists#top"

      resources :genres, only: [:index]

      get "/library", to: "library#index"
      patch "/library", to: "library#update"

    end
  end


end
