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

  def self.from_json(json)
    assignment_hash = {
      name: json["name"],
      spotify_url: json["external_urls"]["spotify"],
      href: json["href"],
      spotify_id: json["id"],
      uri: json["uri"]
    }
    Artist.find_or_create_by(assignment_hash)
  end

  def self.many_from_array(array)
    array.map{|artist| Artist.from_json(artist)}
  end

  def add_images(image_array)
    # handle undefined method `[]' for nil:NilClass error if there is no image
    begin
      assignment_hash = {
        image_url_small: image_array[2]["url"],
        image_url_medium: image_array[1]["url"],
        image_url_large: image_array[0]["url"]
      }
      self.update(assignment_hash)
    rescue NoMethodError
    end
  end

  def self.get_user_artist_ids(user)
    sql = <<-sql
    SELECT DISTINCT artists.id FROM artists
    JOIN artist_tracks ON artist_tracks.artist_id = artists.id
    JOIN tracks ON tracks.id = artist_tracks.track_id
    JOIN track_users ON track_users.track_id = tracks.id
    WHERE track_users.user_id = #{db.quote(user.id)}
    sql
    result = db.execute(sql)
    # return an array of only artist ids
    result.map{|artist| artist["id"]}
  end

  def self.get_user_artists(user)
    Artist.where(id: get_user_artist_ids(user))
  end

  def self.user_library_total(user)
    Artist.get_user_artist_ids(user).length
  end

end
