# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  access_token    :string
#  refresh_token   :string
#  spotify_url     :string
#  profile_img_url :string
#  href            :string
#  uri             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_many :track_users, dependent: :destroy
  has_many :tracks, through: :track_users

  has_many :artists, through: :tracks

  has_many :genres, through: :artists

  validates :username, uniqueness: true, presence: true

  def access_token_expired?
    #return true if access_token is older than 55 minutes, based on update_at
    (Time.now - self.updated_at) > 3300
  end

  def refresh_access_token
    # Check if user's access token has expired
    if access_token_expired?
      #Request a new access token using refresh token
      #Create body of request
      body = {
        grant_type: "refresh_token",
        refresh_token: self.refresh_token,
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV["CLIENT_SECRET"]
      }
      # Send request and updated user's access_token
      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response)
      self.update(access_token: auth_params["access_token"])
    else
      puts "Current user's access token has not expired"
    end
  end

  def save_library
    # Create a new thread to save user library data from Spotify, as this
    # can take a while causing other requests to wait
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        SpotifyAPIAdapter.get_user_library(self)
      end
    end
  end

end
