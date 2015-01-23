require 'spotify-client'
require 'securerandom'
require 'httparty'
require 'yaml'
require 'erb'

module PlaySpotify

	CONFIG = YAML.load(ERB.new(File.read('config.yml')).result)
	SPOTIFY_USER = CONFIG["spotify_id"]

	def client
		@client ||= authenticated_client
	end

	def save_playlist
		store['current_playlist'] = @playlist['id']
	end

	def get_playlist_from_store
		@playlist = get_playlist_from store['current_playlist']
	end

	def authenticated_client
		response = HTTParty.post("https://accounts.spotify.com/api/token",{
			headers: {'Authorization' => "Basic #{CONFIG["spotify_auth_hash"]}"},
			body: {
				grant_type: 'refresh_token',
				refresh_token: CONFIG["spotify_refresh_token"]
			}
			})
		access_token = JSON.parse(response.body)["access_token"]
		@client = Spotify::Client.new access_token: access_token
	end

	def track name
		@item = client.search("track", name).first[1]["items"].first
		@item["uri"]
	end

	def get_playlist_from id
		client.user_playlist SPOTIFY_USER, id
	end

	def last_song_on_playlist
		get_playlist_from(@playlist["id"])["tracks"]["items"].last["track"]["uri"]
	end

	def is_last_song? song
		track(song) === last_song_on_playlist
	end

	def is_current_song? song
		`osascript -e 'tell application "Spotify" to id of current track'`.chomp == track(song)
	end

	def skip
		`osascript -e 'tell application "Spotify" to next track'`
	end

	def create_playlist
		@playlist = client.create_user_playlist SPOTIFY_USER, SecureRandom.hex, true
	end

	def add_to_playlist name
		playlist_id = @playlist["id"]
		client.add_user_tracks_to_playlist SPOTIFY_USER, playlist_id, [track(name)]
	end

	def play song
		`osascript -e 'tell application "Spotify" to play track "#{song}"'`
	end

	def pause
		`osascript -e 'tell application "Spotify" to pause'`
	end

	def resume
		`osascript -e 'tell application "Spotify" to play'`
	end

	def message
		name, artist, album = @item["name"], @item["artists"].first["name"], @item["album"]["name"]
		"'#{name}' by #{artist} from the album '#{album}'"
	end

end