# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  username      :string
#  access_token  :string
#  refresh_token :string
#  spotify_url   :string
#  href          :string
#  uri           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class User < ApplicationRecord
  has_many :track_users
  has_many :tracks, through: :track_users

  validates :username, uniqueness: true, presence: true
end
