class Api::V1::GenresController < ApplicationController

  def index
    # Return the following information:
      # A list of all genres in the user's library, with the count of all
      # artists who belong to that genre, and a list of those artists (limited data)
      # Will allow you to say: X% of your artists' genres are Y
    artist_genres = Genre.user_library_count(current_user)
    artist_genres_total = Genre.user_library_total(current_user)
    artist_ids = Artist.get_user_artist_ids(current_user)
    artists_by_genre = Genre.get_user_artists_by_genre(artist_genres, artist_ids)
    render json: {artists_by_genre: artists_by_genre,
                  artist_genres_total: artist_genres_total}, status: 200
  end
end
