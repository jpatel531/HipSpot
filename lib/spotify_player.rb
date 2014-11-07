require 'spotify-client'
require 'securerandom'

module PlaySpotify

	def client 
		@client ||= Spotify::Client.new access_token: 'BQCbrvp9QCtpalIG31pLdCpsWKlwsLq_5cVU4JJdzVM16vqKzI45UIQCs9HNKT83yoheK9XsS3IVlYy-oA9Laf4v4j5HLnin7JHv7amfeWJuv5JfR9bemGhkMZmg6jku5MHaC9xH8EzMXvm_ljaQyG4stThodqt-v3LLExomRAw'
	end

	def track name
		@item = client.search("track", name).first[1]["items"].first
		@item["uri"]
	end

	def create_playlist
		@playlist = client.create_user_playlist 'jpatel1', SecureRandom.hex
	end

	def add_to_playlist name
		client.add_user_tracks_to_playlist 'jpatel1', @playlist["id"], [track(name)]
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

	def playing_message
		name, artist, album = @item["name"], @item["artists"].first["name"], @item["album"]["name"]
		"Playing '#{name}' by #{artist} from the album '#{album}'"
	end

end