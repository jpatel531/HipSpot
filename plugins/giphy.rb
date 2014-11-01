class Robut::Plugin::Giphy
  include Robut::Plugin

  desc "!gif <query> - responds with a random gif from a Giphy search for <query>"
  match /^!gif (.*)/i do |query|
    gifs_json = Excon.get("http://api.giphy.com/v1/gifs/search?q=#{URI.encode(query)}&api_key=dc6zaTOxFJmzC&limit=100").body
    gifs = JSON.parse(gifs_json)["data"]
    unless gifs.empty?
      gif = gifs.sample
      reply gif['images']['fixed_height']['url']
    else
      reply  "Sorry Master, couldn't find any gif with the query: #{query}"
    end
  end
end