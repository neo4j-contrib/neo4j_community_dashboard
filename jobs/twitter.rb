require 'twitter'
require './lib/api_cache'


if ENV['TWITTER_CONSUMER_KEY']
  twitter = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
  end

  search_term = URI::encode('neo4j OR "graph OR database" OR "graph OR databases" OR graphdb OR graphconnect OR @neoquestions OR @Neo4jDE OR @Neo4jFr OR neotechnology')
  search_term = "#{search_term}"

  SCHEDULER.every '10s', :first_in => 0 do |job|
    yesterday = Time.now - (60 * 60 * 24)

    count = ApiCache.fetch(search_term) do
      twitter.search(search_term, since: yesterday.strftime('%Y-%m-%d')).count
    end

    send_event('twitter', { current: count })
  end
end
