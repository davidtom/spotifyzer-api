class Api::V1::GenresController < ApplicationController

  def index
    #TODO: DELETE BELOW LINE SO WE ALWAYS DEAL WITH THE CURRENT USER
    current_user = User.find(1)
    # TODO: SEE ABOVE

    # Return the following information:
      # A list of all genres in the user's library, with the count of all artists who belong to that genre
      # The total number of genres of all artists in the library (not unique)
      # Will allow you to say: X% of your artists' genres are Y
      # Artists, image_urls, and links for artists in your top 5 genres

    artist_genres = Genre.user_library_list(current_user)
    artist_genres_total = Genre.user_library_count(current_user)
    # TODO: Find out how to return the following json:
    # {genres: {name: "indietronica", artists:[{},{},{}]}}
    top_5_genre_ids = artist_genres.first(5).map{|genre| genre["id"]}
    top_genre_artists = Artist.get_by_genre_ids(top_5_genre_ids)
    render json: {artist_genres: artist_genres, artist_genres_total: artist_genres_total, top_genre_artists: "TBD"}, status: 200
  end
end
