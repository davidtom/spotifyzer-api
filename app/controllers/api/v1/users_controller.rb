class Api::V1::UsersController < ApplicationController

  skip_before_action :authorized

  def create
    # Assemble and send request to Spotify for access and refresh tokens
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
    # Add or update user's profile image:
    img_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
    @user.update(profile_img_url: img_url)
    # Update the access and refresh tokens in the database
    @user.update(access_token:auth_params["access_token"], refresh_token: auth_params["refresh_token"])

    # Create and send JWT Token for user
    payload = {user_id: @user.id}
    token = issue_token(payload)
    render json: {jwt: token, user: {
                                username: @user.username,
                                spotify_url: @user.spotify_url,
                                profile_img_url: @user.profile_img_url
                                }
                              }
    # If user was just created and has no tracks saved, get them from Spotify
    # Test threading
    # Thread.new do
    #   puts "im async!"
    #   puts SpotifyAPIAdapter.get_user_top_tracks(@user)
    # end
  end

end
