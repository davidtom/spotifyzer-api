class SpotifyAPIAdapter < ApplicationController

  def get_current_user_library
    # Update user's refresh token if necessary
    current_user.refresh_access_token

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

  def persist_user_library(items)
    # TODO: decide if this belongs here or in one of the models??

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
      TrackUser.create(user_id: current_user.id,
                      track_id: track.id,
                      added_at: item["added_at"])
    end
  end

  def persist_additional_artist_data(artist)
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
    # Handle validation error from assigning a genre to an artist more than once
    genres.each do |genre|
      begin
         artist.genres << genre
      rescue ActiveRecord::RecordInvalid => invalid
        puts invalid.record.errors.inspect
      end
    end
  end

  def get_user_top_artists(time_range)
    # Update user's refresh token if necessary
    current_user.refresh_access_token

    # Construct and send API call to get artist data (genre and album art)
    api_url = "https://api.spotify.com/v1/me/top/artists/"
    header = {
      Authorization: "Bearer #{current_user.access_token}"
    }
    query_params = {
      limit: 50,
      time_range: time_range
    }
    url = "#{api_url}?#{query_params.to_query}"
    response = JSON.parse(RestClient.get(url, header))
    # Parse and return only artists from response
    response["items"]
  end

  def get_user_top_tracks(time_range)
    # Update user's refresh token if necessary
    current_user.refresh_access_token

    # Construct and send API call to get artist data (genre and album art)
    api_url = "https://api.spotify.com/v1/me/top/tracks/"
    header = {
      Authorization: "Bearer #{current_user.access_token}"
    }
    query_params = {
      limit: 50,
      time_range: time_range
    }
    url = "#{api_url}?#{query_params.to_query}"
    response = JSON.parse(RestClient.get(url, header))
    # Parse and return only artists from response
    response["items"]
  end

end
