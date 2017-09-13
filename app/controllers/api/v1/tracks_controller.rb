class Api::V1::TracksController < ApplicationController

  def index
    tracks = current_user.tracks
    render json: tracks, status: 200
  end

  def top
    time_range = params[:time_range] || "medium_term"
    top_tracks = SpotifyAPIAdapter.get_user_top_tracks(current_user, time_range)
    render json: top_tracks, status: 200
  end

  def recent
    recent_track_data = SpotifyAPIAdapter.get_user_recent_tracks(current_user)
    render json: recent_track_data, status: 200
  end

end
