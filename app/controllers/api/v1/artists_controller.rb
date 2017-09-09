class Api::V1::ArtistsController < ApplicationController

  def index
    artists = current_user.artists.distinct
    render json: artists, status: 200
  end

  def top
   time_range = params[:time_range] || "medium_term"
   top_artists = SpotifyAPIAdapter.get_user_top_artists(current_user, time_range)
   render json: top_artists, status: 200
  end
end
