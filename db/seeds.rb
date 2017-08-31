# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Test track with one artist
user1 = User.create(username: "david")
track1 = Track.create(name: "Mr Brightside", spotify_id: "whatever1")
artist1 = Artist.create(name: "The Killers", spotify_id: "whatever1")
album1 = Album.create(name: "Hot Fuss", spotify_id: "whatever1")
genre1 = Genre.create(name: "Pop")
genre2 = Genre.create(name: "Alternative")

artist1.tracks << track1
album1.tracks << track1
genre1.artists << artist1
genre2.artists << artist1
user1.tracks << track1

# Test track with multiple artists
user2 = User.create(username: "jenni")
track2 = Track.create(name: "If I never see your face again", spotify_id: "whatever2")
artist2 = Artist.create(name: "Maroon 5", spotify_id: "whatever2")
artist3 = Artist.create(name: "Rihanna", spotify_id: "whatever3")
album2 = Album.create(name: "It wont be soon before long", spotify_id: "whatever2")
genre3 = Genre.create(name: "R&B")

artist2.tracks << track2
artist3.tracks << track2
album2.tracks << track2
genre1.artists << artist2
genre1.artists << artist3
genre2.artists << artist2
genre2.artists << artist3
genre3.artists << artist3
user2.tracks << track1
user2.tracks << track2
