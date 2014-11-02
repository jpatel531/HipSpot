require 'spotify-client'

module PlaySpotify

	def track name
		client = Spotify::Client.new
		@item = client.search("track", name).first[1]["items"].first
		@item["uri"]
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