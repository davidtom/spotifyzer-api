# == Schema Information
#
# Table name: track_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  track_id   :integer
#  added_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TrackUser < ApplicationRecord
  belongs_to :track
  belongs_to :user

  validates :track_id, uniqueness: {scope: :user_id,
    message: "a track should exist only once for each user"}
end
