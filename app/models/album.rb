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
end
