class SpotifyAPIAdapter < ApplicationController

  def self.refresh_token
    #TODO: DELETE BELOW LINE SO WE ALWAYS DEAL WITH THE CURRENT USER
    current_user = User.find(1)
    # TODO: SEE ABOVE

    # Check if user's access token has expired
    if current_user.access_token_expired?
      #Request a new access token using refresh token
      #Create body of request
      body = {
        grant_type: "refresh_token",
        refresh_token: current_user.refresh_token,
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV["CLIENT_SECRET"]
      }
      # Send request and updated user's access_token
      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response)
      current_user.update(access_token: auth_params["access_token"])
    else
      puts "Current user's access token has not expired"
    end
  end

  def self.get_current_user_library
    #TODO: DELETE BELOW LINE SO WE ALWAYS DEAL WITH THE CURRENT USER
    current_user = User.find(1)
    # TODO: SEE ABOVE
    refresh_token
    # Formulate and send get request for current_user's library and convert to JSON
    header = {
      Authorization: "Bearer #{current_user.access_token}"
    }
    query_params = {
      limit: 50
    }
    url = "https://api.spotify.com/v1/me/tracks"
    response = JSON.parse(RestClient.get("#{url}?#{query_params.to_query}", header))
    # Iterate over library items and persist each in the database
    persist_library_items(response)

  end

  def self.persist_library_items(json)
    json["items"].each do |item|
      track = item["track"]
      album = track["album"]
      # artists is an array, with genre attached to each one
      artists = track["artists"]
      byebug
      # TODO: 1) Create methods in each model to assign this data
      #       2) Create logic to go through pages (probably another method)
      #       3) Run this again to make sure that only new data is persisted
      #       4) FIX THE REFRESH TOKEN FLOW - try to make it a before_action!
      #       5) There also seems to be an issue with it being run and the request not having update data in time
      #       6) Idea for loading current data in react then sending a second thunk request from react wich waits for data from rails after rails finishes checking for updates. Test with byebug!
    end
  end


end
