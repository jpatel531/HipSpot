require_relative '../hip_spot'

# play track "come fly with me sinatra"

class Robut::Plugin::HipSpot

	include Robut::Plugin
	include PlaySpotify

	desc "!play <query> plays the desired Spotify tune"

  	match /^!play (.*)/ do |query|

  		# raise query.inspect

  		play track query

  		reply query

	    # image = Google::Search::Image.new(:query => query, :safe => :active).first

	    # if image
	    #   reply image.uri
	    # else
	    #   reply "Couldn't find an image"
	    # end

	    # play track query

	    # reply "Playing #{query}"

  	end



end