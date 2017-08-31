class CreateArtistTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :artist_tracks do |t|
      t.integer :artist_id
      t.integer :track_id

      t.timestamps
    end
  end
end
