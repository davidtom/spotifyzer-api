class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :name
      t.integer :duration_ms
      t.boolean :explicit
      t.string :spotify_url
      t.string :href
      t.string :spotify_id
      t.string :preview_url
      t.string :uri
      t.integer :album_id

      t.timestamps
    end
  end
end
