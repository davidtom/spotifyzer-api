class Api::V1::GenresController < ApplicationController

  def index
    ## Returns a list of all genres in the user's library, with all artists
    ## in the user's library who are in that genre

    # Check if user's full library is saved (ie a thread is not saving it)
    if current_user.full_library
      # Get a list of all genres in the user's library
      user_library_genres = current_user.genres.distinct.select(:id, :name)
      # Get a list of all artists (id only) in the user's library
      artist_ids = current_user.artists.distinct.select(:id)
      # For each genre in the users's library, get a list of all the artists
      # in the user's library who match that genre
      artists_by_genre = Genre.list_with_artists_by_ids(user_library_genres, artist_ids)
      render json: {artists_by_genre: artists_by_genre,
                    total_artists: artist_ids.length}, status: 200
    else
    # If a thread is currently saving the library, report that to client
      render json: {loading_library: !current_user.full_library}
    end
  end
end
