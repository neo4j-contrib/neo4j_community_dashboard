require './lib/api_cache'

class UrlCache
  def self.get_url_body(url, options = {expires_in: 3.hours})
    require 'open-uri'
    ApiCache.fetch(url, options) do
      URI.parse(url).open.read
    end
  end
end

