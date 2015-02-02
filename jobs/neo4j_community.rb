require 'open-uri'
require './lib/url_cache'

def stack_overflow_question_count
  puts 'querying stack overflow...'
  url = 'https://api.stackexchange.com/2.2/tags/neo4j/info?order=desc&sort=popular&site=stackoverflow'

  JSON.parse(UrlCache.get_url_body(url))['items'][0]['count']
end

def github_repo_count
  puts 'querying github...'
  url = 'https://api.github.com/search/repositories?q=neo4j'

  JSON.parse(UrlCache.get_url_body(url))['total_count']
end

def meetup_member_count
  puts 'querying meetup'
  url = 'https://api.meetup.com/topics.json/?name=neo4j&key=' + ENV['MEETUP_API_KEY']

  topic = JSON.parse(UrlCache.get_url_body(url))['results'].detect do |topic|
    topic['urlkey'] == 'neo4j'
  end

  topic['members'].to_i
end

send_event('stack_overflow', current: stack_overflow_question_count)
send_event('github', current: github_repo_count)
send_event('meetup_members', current: meetup_member_count)

SCHEDULER.every '10s' do
  send_event('stack_overflow', current: stack_overflow_question_count)
  send_event('github', current: github_repo_count)
  send_event('meetup_members', current: meetup_member_count)
end

