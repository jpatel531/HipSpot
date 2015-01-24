class Track

	extend Client 

	class << self
		def from_name(name)
			track_data = client.search("track", name).first[1]["items"].first
			new track_data
		end
	end

	attr_reader :id

	def initialize(track_data)
		@item = track_data
		@id = @item["uri"]
	end

	def message
		name, artist, album = @item["name"], @item["artists"].first["name"], @item["album"]["name"]
		"'#{name}' by #{artist} from the album '#{album}'"
	end

end