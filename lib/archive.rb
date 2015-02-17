class Archive

	extend Client

	def self.fetch(url='https://api.spotify.com/v1/users/jpatel1/playlists/226MERlK3yiZNWm8mbt8Lv', current_offset=nil, max_offset=nil, archive=[])
		response = HTTParty.get(url, { headers: {'Authorization' => "Bearer #{client.access_token}"}})

		playlist = JSON.parse(response.body)

		items = (current_offset) ? playlist['items'] : playlist['tracks']['items']

		url = (current_offset) ? playlist['next'] : playlist['tracks']['next']

		current_offset = (current_offset) ? playlist['offset'] : playlist['tracks']['offset']		

		max_offset ||= (playlist['tracks']['total'] / 100) * 100

		archive += items.map {|item| item['track']['uri'] }
	
		(current_offset == max_offset) ? archive.uniq : fetch(url, current_offset, max_offset, archive)
	end

end