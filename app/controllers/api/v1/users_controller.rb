class Api::V1::UsersController < ApplicationController

  def login
    # User has clicked "login" button - assemble get request to Spotify to have
    # user authorize application
    query_params = {
      client_id: ENV['CLIENT_ID'],
      response_type: "code",
      redirect_uri: ENV['REDIRECT_URI'],
      scope: "user-library-read user-library-modify user-top-read user-modify-playback-state playlist-modify-public playlist-modify-private ugc-image-upload user-read-recently-played",
      show_dialog: true
    }
    url = "https://accounts.spotify.com/authorize/"
    # redirects user's browser to Spotify's authorization page, which details
    # scopes my app is requesting
    redirect_to "#{url}?#{query_params.to_query}"
  end

  def callback
    # handle response from Spotify, which either gives an error or response data
    if params[:error]
      puts "LOGIN ERROR", params
      redirect_to "http://localhost:3001/login/failure"
    else
      # Assemble request to Spotify for access and refresh tokens
      body = {
        grant_type: "authorization_code",
        code: params[:code],
        redirect_uri: ENV['REDIRECT_URI'],
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV["CLIENT_SECRET"]
      }
      # Send response to Spotify for access and refresh tokens
      response = RestClient.post('https://accounts.spotify.com/api/token', body)
      # Log results in console (temporary)
      puts "PRINTING BODY"
      puts response.body
      # TODO: this is where I should save the returned tokens
      # Redirect user to main page
      redirect_to "http://localhost:3001/success"
    end
  end

end
