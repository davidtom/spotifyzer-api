# == Schema Information
#
# Table name: artist_genres
#
#  id         :integer          not null, primary key
#  artist_id  :integer
#  genre_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArtistGenre < ApplicationRecord
  belongs_to :genre
  belongs_to :artist

  validates :genre_id, uniqueness: {scope: :artist_id,
    message: "an genre should exist only once for each artist"}
end
