class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  @@db = ActiveRecord::Base.connection

  def self.db
    @@db
  end
end
