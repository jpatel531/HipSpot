require 'spotify-client'
require 'securerandom'
require 'httparty'

module PlaySpotify

	def client 
		@client ||= Spotify::Client.new access_token: 'BQBlcsRI04FRsUEYBFyYvmBufVPpQ8CTOPhG5753_BjTJKNdsVOGlIDBoSBlnvCnH1IdQs9rr5we7k4Z3quUgO2C3FpDyNCX20eKQSJ6zlZARzysUHva_6gZ7jTVcKarXHVEg235RmEw21j0U87Eh-qmU9N-vysCngPSLIefJ5Y'
		@client.me ? @client : refresh_token
	end

	def save_playlist
		store['current_playlist'] = @playlist['id']
	end

	def refresh_token
		response = `curl -X POST https://accounts.spotify.com/api/token -d grant_type=refresh_token -d refresh_token=#{ENV["SPOTIFY_REFRESH_TOKEN"]} -H "Authorization: Basic #{ENV["SPOTIFY_HASH"]}"`
		access_token = JSON.parse(response)["access_token"]
		@client = Spotify::Client.new access_token: access_token
	end

	def track name
		@item = client.search("track", name).first[1]["items"].first
		@item["uri"]
	end

	def get_playlist_from id
		client.user_playlist('jpatel1', id)
	end

	def create_playlist
		@playlist = client.create_user_playlist 'jpatel1', SecureRandom.hex, true
	end

	def add_to_playlist name
		playlist_id = @playlist["id"]
		client.add_user_tracks_to_playlist 'jpatel1', playlist_id, [track(name)]
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