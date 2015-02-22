# end_checker = Thread.new do

require_relative 'base'

def store_beyond_last_song(store, beyond_last_song)
	store['beyond_last_song'] = beyond_last_song
	File.open('.robut', 'w') {|f| f.write store.to_yaml } #Store
end

loop do 
	begin

		current_song = SpotifyController.current_song
		next if current_song == @current_song

		store = YAML.load(File.read('.robut'))
		id = store['current_playlist']
		playlist = Playlist.from_id(id)

		@current_song = current_song

		beyond_last_song = @playing_last_song && (@current_song == playlist.first_song) 

		store_beyond_last_song(store, beyond_last_song)

		puts "Playlist completed? #{beyond_last_song}"

		break if beyond_last_song

		@playing_last_song = (SpotifyController.current_song == playlist.last_song)

		puts "Playing last song? #{@playing_last_song}"


		sleep 1

	rescue
		next
	end
end
