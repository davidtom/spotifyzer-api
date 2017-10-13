# Spotifyzer-api
* Rails API for Spotifyzer - an app that allows users to analyze their Spotify library and listening habits
* Provides data and makes Spotify API calls for React front end ([repo](https://github.com/davidtom/spotifyzer))
* View live site [here](https://spotifyzer-fe.herokuapp.com/) (please be patient while Heroku wakes up)

## Features
* Authorizes users through Spotify's [Authorization Code Flow](https://developer.spotify.com/web-api/authorization-guide/), in tandem with front end
* Requires authorization for all API requests
* Utilizes Ruby's Thread class to avoid IO blocking when persisting a user's saved library data (which may take anywhere from a few seconds to a couple of minutes depending on its size)

## Architecture
* See ```app``` for application code
* Utilizes the [Spotify Web API](https://developer.spotify.com/web-api/) to authorize users and access private data
  * In order to use this repo, you must [register](https://developer.spotify.com/my-applications/#!/applications) your app with Spotify and store the client id, secret key, redirect uri, etc. as environment variables (I recommend the [Figaro gem](https://github.com/laserlemon/figaro))
* [PostreSQL](https://www.postgresql.org/) database stores basic user info and library data
