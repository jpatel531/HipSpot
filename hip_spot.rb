require 'spotify-client'

@client = Spotify::Client.new

def track name
	@client.search("track", name).first[1]["items"].first["uri"]
end

def play song
`osascript -e 'tell application "Spotify" to play track "#{song}"'`
end