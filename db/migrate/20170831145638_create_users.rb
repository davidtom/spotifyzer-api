class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :access_token
      t.string :refresh_token
      t.string :spotify_url
      t.string :profile_img_url
      t.string :href
      t.string :uri

      t.timestamps
    end
  end
end
