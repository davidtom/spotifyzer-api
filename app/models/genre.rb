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

end
