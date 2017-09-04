class Api::V1::LibraryController < ApplicationController

  def index
    # Return an overview of the current user's library:
      # Total count of tracks, artists, and genres
    tracks_count = Track.user_library_total(current_user)
    artists_count = Artist.user_library_total(current_user)
    genres_count = Genre.user_library_total(current_user)
    render json: {tracks: tracks_count, artists: artists_count, genres: genres_count} , status: 200
  end
end
