class Api::V1::UsersController < ApplicationController

  def create
    # handle response from Spotify, which either gives an error or response data
    if params[:error]
      # return error message if there is one
      puts "LOGIN ERROR", params
      redirect_to "http://localhost:3001/login/failure"
    else
      # If no error, assemble and send request to Spotify for access and refresh tokens
      body = {
        grant_type: "authorization_code",
        code: params[:code],
        redirect_uri: ENV['REDIRECT_URI'],
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV["CLIENT_SECRET"]
      }
      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      # convert response.body to json for assisgnment
      auth_params = JSON.parse(auth_response.body)
      # assemble and send request to Spotify for user profile information
      header = {
        Authorization: "Bearer #{auth_params["access_token"]}"
      }
      user_response = RestClient.get("https://api.spotify.com/v1/me", header)
      # convert response.body to json for assisgnment
      user_params = JSON.parse(user_response.body)
      # Create new user based on response, or find the existing user in database
      @user = User.find_or_create_by(username: user_params["id"],
                        spotify_url: user_params["external_urls"]["spotify"],
                        href: user_params["href"],
                        uri: user_params["uri"])
      # Update the access and refresh tokens in the database
      @user.update(access_token:auth_params["access_token"], refresh_token: auth_params["refresh_token"])
      # Redirect user to main page
      redirect_to "http://localhost:3001/dashboard"
    end
  end

end
