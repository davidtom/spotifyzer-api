class Api::V1::ArtistsController < ApplicationController

  def index
    artists = Artist.get_user_artists(current_user)
    render json: artists, status: 200
  end

  def top
   s = SpotifyAPIAdapter.new
   time_range = params[:time_range] || "medium_term"
   top_artists = s.get_user_top_artists(time_range)
   render json: top_artists, status: 200
  end
end
