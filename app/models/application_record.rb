class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Create a class variable and method for db connection to write sql in models
  @@db = ActiveRecord::Base.connection

  def self.db
    @@db
  end
end
