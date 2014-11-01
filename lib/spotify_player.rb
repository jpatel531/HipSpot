require 'spotify-client'

module PlaySpotify

	def track name
		client = Spotify::Client.new
		client.search("track", name).first[1]["items"].first["uri"]
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

end