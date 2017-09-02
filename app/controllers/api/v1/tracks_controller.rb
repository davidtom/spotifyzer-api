class Api::V1::TracksController < ApplicationController

  def index
    tracks = Track.get_user_tracks(current_user)
    render json: tracks, status: 200
  end

  def top
   s = SpotifyAPIAdapter.new
   time_range = params[:time_range] || "medium_term"
   top_tracks = s.get_user_top_tracks(time_range)
   render json: top_tracks, status: 200
  end

end
