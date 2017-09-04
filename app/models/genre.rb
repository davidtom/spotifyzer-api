# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Genre < ApplicationRecord
  has_many :artist_genres
  has_many :artists, through: :artist_genres

  validates :name, uniqueness: true, presence: true

  def self.many_from_array(array)
    array.map{|genre| Genre.find_or_create_by(name: genre)}
  end

  def self.user_library_count(user)
    # Returns all genres of all artists in a user's library, grouped and counted by genre name
    sql = <<-sql
    SELECT name, genres.id, COUNT(*) as count FROM genres
    JOIN artist_genres ON genres.id = artist_genres.genre_id
    AND artist_genres.artist_id IN (
      SELECT DISTINCT artists.id FROM artists
      JOIN artist_tracks ON artist_tracks.artist_id = artists.id
      JOIN tracks ON tracks.id = artist_tracks.track_id
      JOIN track_users ON track_users.track_id = tracks.id
      WHERE track_users.user_id = #{db.quote(user.id)}
    )
    GROUP BY genres.name, genres.id
    ORDER BY count DESC
    sql
    JSON.parse(db.execute(sql).to_json)
  end

  def self.user_library_total(user)
    # returns the total count of the (unique) genres of all artists in the user's library
    sql = <<-sql
    SELECT DISTINCT genres.id FROM genres
    JOIN artist_genres ON genres.id = artist_genres.genre_id
    AND artist_genres.artist_id IN (
      SELECT DISTINCT artists.id FROM artists
      JOIN artist_tracks ON artist_tracks.artist_id = artists.id
      JOIN tracks ON tracks.id = artist_tracks.track_id
      JOIN track_users ON track_users.track_id = tracks.id
      WHERE track_users.user_id = #{db.quote(user.id)}
    )
    sql
    result = JSON.parse(db.execute(sql).to_json)
    result.length
  end

  def self.get_user_artists_by_genre(artist_genre_json, user_artist_ids)
    artist_genre_json.map do |genre|
      artists = Genre.find(genre["id"]).artists.where(id: user_artist_ids).select(:id, :name, :spotify_url, :image_url_small)
      {name: genre["name"],
        id: genre["id"],
        count: artists.length,
        artists: artists
      }
    end
  end

end
