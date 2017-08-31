# == Schema Information
#
# Table name: artist_tracks
#
#  id         :integer          not null, primary key
#  artist_id  :integer
#  track_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArtistTrack < ApplicationRecord
  belongs_to :artist
  belongs_to :track

  validates :track_id, uniqueness: {scope: :artist_id,
    message: "a track should exist only once for each artist"}
end
