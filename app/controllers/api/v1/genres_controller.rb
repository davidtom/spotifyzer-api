class Api::V1::GenresController < ApplicationController

  def index
    # TODO docstring
    # Get a list of all genres in the user's library
    user_library_genres = current_user.genres.distinct.select(:id, :name)
    # Get a list of all artists (id only) in the user's library
    artist_ids = current_user.artists.distinct.select(:id)
    # For each genre in the users's library, get a list of all the artists
    # in the user's library who match that genre
    artists_by_genre = Genre.list_with_artists_by_ids(user_library_genres, artist_ids)

    render json: {artists_by_genre: artists_by_genre,
                  total_artists: artist_ids.length}, status: 200
  end
end
