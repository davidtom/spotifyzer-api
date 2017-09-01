# == Schema Information
#
# Table name: albums
#
#  id               :integer          not null, primary key
#  name             :string
#  spotify_id       :string
#  spotify_url      :string
#  href             :string
#  uri              :string
#  image_url_small  :string
#  image_url_medium :string
#  image_url_large  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Album < ApplicationRecord
  has_many :tracks

  validates :spotify_id, uniqueness: true
  validates :name, presence: true

  def self.from_json(json)
    assignment_hash = {
      name: json["name"],
      spotify_id: json["id"],
      spotify_url: json["external_urls"]["spotify"],
      href: json["href"],
      uri: json["uri"],
      image_url_small: json["images"][2]["url"],
      image_url_medium: json["images"][1]["url"],
      image_url_large: json["images"][0]["url"]
    }
    Album.find_or_create_by(assignment_hash)
  end
end
