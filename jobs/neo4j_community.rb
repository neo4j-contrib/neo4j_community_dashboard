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

send_event('stack_overflow', current: stack_overflow_question_count)
send_event('github', current: github_repo_count)

SCHEDULER.every '10s' do
  send_event('stack_overflow', current: stack_overflow_question_count)
  send_event('github', current: github_repo_count)
end

