class Api::V1::LibraryController < ApplicationController

  def index
    # Return an overview of the current user's library:
      # Total count of tracks, artists, and genres
    tracks_count = current_user.tracks.length
    artists_count = current_user.artists.distinct.length
    genres_count = current_user.genres.distinct.length
    render json: {tracks: tracks_count, artists: artists_count, genres: genres_count} , status: 200
  end
end
