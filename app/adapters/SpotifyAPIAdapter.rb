module
  def Spotify.get_user_library(user)
    # Update user's refresh token if necessary
    user.refresh_access_token

    # Create header and parameters for API get request for user's library
    header = {
      Authorization: "Bearer #{user.access_token}"
    }
    query_params = {
      limit: 50
    }
    initial_url = "https://api.spotify.com/v1/me/tracks"

    # Initialize variables to control looping through response pages
    next_page = true
    response = nil
    # Loop over response pages, saving user's library data until there is not a "next" key
    while next_page do
      url = !response ?  "#{initial_url}?#{query_params.to_query}" : response["next"]
      begin
        response = JSON.parse(RestClient.get(url, header))
      rescue RestClient::Exceptions::OpenTimeout
        # If there is a timeout error, force loop to exit
        response = {}
      end
      persist_user_library(user, response["items"])
      next_page = false if !response["next"]
    end
  end

  
end
