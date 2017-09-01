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

  def self.from_json(json)
    assignment_hash = {
      name: json["name"],
      duration_ms: json["duration_ms"],
      explicit: json["explicit"],
      spotify_url: json["external_urls"]["spotify"],
      href: json["href"],
      spotify_id: json["id"],
      preview_url: json["preview_url"],
      uri: json["uri"]
    }
    Track.find_or_create_by(assignment_hash)
  end


end
