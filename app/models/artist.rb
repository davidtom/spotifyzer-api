# == Schema Information
#
# Table name: artists
#
#  id               :integer          not null, primary key
#  name             :string
#  spotify_url      :string
#  href             :string
#  spotify_id       :string
#  uri              :string
#  image_url_small  :string
#  image_url_medium :string
#  image_url_large  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Artist < ApplicationRecord
  has_many :artist_tracks
  has_many :tracks, through: :artist_tracks

  has_many :artist_genres
  has_many :genres, through: :artist_genres

  validates :spotify_id, uniqueness: true
  validates :name, presence: true
end
