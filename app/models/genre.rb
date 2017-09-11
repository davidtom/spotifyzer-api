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
    array.map{|genre| Genre.find_or_create_by(name: genre.titleize)}
  end

  def artists_by_ids(artist_ids)
    # Find all of the genre's artists that match a list of artist ids
    self.artists.where(id: artist_ids).select(:id, :name, :spotify_url, :uri, :image_url_small)
  end

  def self.list_with_artists_by_ids(genres, artist_ids)
    # Given an array of genres and an array of artists ids, return a new array
    # of hashes with the following: Genre name, genre id, count of artists in
    # that genre that are in the artst_id array, and an array of those artists
    # Finally, sort this array in descending order by artist count
    genres.map do |genre|
      artists = genre.artists_by_ids(artist_ids)
      {id: genre.id,
       name: genre.name,
       count: artists.length,
       artists: artists
      }
    end.sort_by {|genre| genre[:count]}.reverse
  end

end
