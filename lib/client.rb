module Client

	CONFIG = YAML.load(ERB.new(File.read('config.yml')).result)
	SPOTIFY_USER = CONFIG["spotify_id"]

	def client
		@client ||= authenticated_client
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
end