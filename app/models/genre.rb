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

  def self.user_library_list(user)
    # Returns all genres of all artists in a user's library, grouped and counted by genre name
    a = ActiveRecord::Base.connection
    sql = <<-sql
    SELECT name, genres.id, COUNT(*) as count FROM genres
    JOIN artist_genres ON genres.id = artist_genres.genre_id
    AND artist_genres.artist_id IN (
      SELECT DISTINCT artists.id FROM artists
      JOIN artist_tracks ON artist_tracks.artist_id = artists.id
      JOIN tracks ON tracks.id = artist_tracks.track_id
      JOIN track_users ON track_users.track_id = tracks.id
      WHERE track_users.user_id = #{a.quote(user.id)}
    )
    GROUP BY genres.name, genres.id
    ORDER BY count DESC
    sql
    JSON.parse(a.execute(sql).to_json)
  end

  def self.user_library_count(user)
    # returns the total count (single integer) of the genres of all artists in the user's library
    a = ActiveRecord::Base.connection
    sql = <<-sql
    SELECT COUNT(*) as total FROM genres
    JOIN artist_genres ON genres.id = artist_genres.genre_id
    AND artist_genres.artist_id IN (
      SELECT DISTINCT artists.id FROM artists
      JOIN artist_tracks ON artist_tracks.artist_id = artists.id
      JOIN tracks ON tracks.id = artist_tracks.track_id
      JOIN track_users ON track_users.track_id = tracks.id
      WHERE track_users.user_id = #{a.quote(user.id)}
    )
    sql
    JSON.parse(a.execute(sql).to_json)
  end

end
