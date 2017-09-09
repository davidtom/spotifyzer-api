class Api::V1::LibraryController < ApplicationController

  def index
    ## Return an overview of the current user's library:
    ## Total count of tracks, artists, and genres; time last updated_at

    # Check if user's full library is saved (ie a thread is not saving it)
    if current_user.full_library
      tracks_count = current_user.tracks.length
      artists_count = current_user.artists.distinct.length
      genres_count = current_user.genres.distinct.length
      render json: {tracks: tracks_count,
                    artists: artists_count,
                    genres: genres_count,
                    last_update: current_user.track_users.order("updated_at").last.updated_at.to_date},
                    status: 200
    else
    # If a thread is currently saving the library, report that to client
      render json: {loading_library: !current_user.full_library}
    end
  end

  def update
    current_user.save_library
    render json: {loading_library: !current_user.full_library}
  end
end
