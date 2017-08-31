# == Schema Information
#
# Table name: tracks
#
#  id          :integer          not null, primary key
#  name        :string
#  duration_ms :integer
#  explicit    :boolean
#  spotify_url :string
#  href        :string
#  spotify_id  :string
#  preview_url :string
#  uri         :string
#  album_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Track < ApplicationRecord
  has_many :track_users
  has_many :users, through: :track_users

  has_many :artist_tracks
  has_many :artists, through: :artist_tracks

  belongs_to :album, optional: true

  validates :spotify_id, uniqueness: true
  validates :name, presence: true
end
