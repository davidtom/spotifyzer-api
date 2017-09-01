class SpotifyAPIAdapter

  # TODO:
  #       6) Idea for loading current data in react then sending a second thunk request from react wich waits for data from rails after rails finishes checking for updates. Test with byebug!
  #       7) Archive discover playlist? Make a cool transition/image slider or whatever for showing (allow users to start them so they dont have to save all)

  def self.get_current_user_library
    #TODO: DELETE BELOW LINE SO WE ALWAYS DEAL WITH THE CURRENT USER
    current_user = User.find(1)
    # TODO: SEE ABOVE

    # Update user's refresh token if necessary
    current_user.update_refresh_token

    # Create header and parameters for API get request for user's library
    header = {
      Authorization: "Bearer #{current_user.access_token}"
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
      response = JSON.parse(RestClient.get(url, header))
      persist_user_library(response["items"])
      next_page = false if !response["next"]
    end

  end

  def self.persist_user_library(items)
    # iterate over each item (a track in the user's library) and persist/create associations
    items.each do |item|
      track = Track.from_json(item["track"])
      album = Album.from_json(item["track"]["album"])
      album.tracks << track
      artists = Artist.many_from_array(item["track"]["artists"])
      # Handle validation error from assigning a track to an artist more than once
      artists.each do |artist|
        persist_additional_artist_data(artist)
        begin
          artist.tracks << track
        rescue ActiveRecord::RecordInvalid => invalid
          puts invalid.record.errors.inspect
        end
      end
      TrackUser.create(user_id: 1,
                      track_id: track.id,
                      added_at: item["added_at"])
    end
  end

  def self.persist_additional_artist_data(artist)
    #TODO: DELETE BELOW LINE SO WE ALWAYS DEAL WITH THE CURRENT USER
    current_user = User.find(1)
    # TODO: SEE ABOVE

    # Construct and send API call to get artist data (genre and album art)
    url = "https://api.spotify.com/v1/artists/#{artist.spotify_id}"
    header = {
      Authorization: "Bearer #{current_user.access_token}"
    }
    response = JSON.parse(RestClient.get(url, header))

    # Save artist images
    artist.add_images(response["images"])
    # Create and save artist's genre(s)
    genres = Genre.many_from_array(response["genres"])
    genres.each{|genre| artist.genres << genre}
  end

end
