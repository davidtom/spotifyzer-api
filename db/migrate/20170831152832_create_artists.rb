class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :spotify_url
      t.string :href
      t.string :spotify_id
      t.string :uri
      t.string :image_url_small
      t.string :image_url_medium
      t.string :image_url_large

      t.timestamps
    end
  end
end
