class SpotifyAPIAdapter

  def self.get_current_user_library
    #TODO: DELETE BELOW LINE SO WE ALWAYS DEAL WITH THE CURRENT USER
    current_user = User.find(1)
    # TODO: SEE ABOVE

    current_user.update_refresh_token
    # Formulate and send get request for current_user's library and convert to JSON
    header = {
      Authorization: "Bearer #{current_user.access_token}"
    }
    query_params = {
      limit: 50
    }
    url = "https://api.spotify.com/v1/me/tracks"
    response = JSON.parse(RestClient.get("#{url}?#{query_params.to_query}", header))
    parse_response_pages(response)
  end

  def self.persist_user_library(items)
    # iterate over each item (a track in the user's library) and persist/create associations
    items.each do |item|
      track = Track.from_json(item["track"])
      album = Album.from_json(item["track"]["album"])
      album.tracks << track
      # artists is an array, with genre attached to each one
      artists = Artist.many_from_array(item["track"]["artists"])
      artists.each {|artist| artist.tracks << track}
      TrackUser.create(user_id: 1,
                      track_id: track.id,
                      added_at: item["added_at"])
      # TODO:
      #       2) Create logic to go through pages (probably another method)
      #       3) Run this again to make sure that only new data is persisted
      #       4) FIX THE REFRESH TOKEN FLOW - try to make it a before_action!
      #       5) There also seems to be an issue with it being run and the request not having update data in time
      #       6) Idea for loading current data in react then sending a second thunk request from react wich waits for data from rails after rails finishes checking for updates. Test with byebug!
      #       7) Archive discover playlist? Make a cool transition/image slider or whatever for showing (allow users to start them so they dont have to save all)
    end
  end

  def self.parse_response_pages(response)
    byebug
    while
    # Iterate over library tracks (in key "items") and persist each in the database
    # persist_user_library(response["items"])
  end

end
