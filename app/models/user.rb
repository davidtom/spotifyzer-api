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

  def access_token_expired?
    #return true if access_token is older than 55 minutes, based on update_at
    (Time.now - self.updated_at) > 3300
  end

end
