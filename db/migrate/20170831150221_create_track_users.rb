class CreateTrackUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :track_users do |t|
      t.integer :user_id
      t.integer :track_id
      t.datetime :added_at

      t.timestamps
    end
  end
end
