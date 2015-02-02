require 'active_support'

ApiCache = if ENV['REDISCLOUD_URL']
             require 'redis-activesupport'
             ActiveSupport::Cache::RedisStore.new(ENV['REDISCLOUD_URL'])
           else
             ActiveSupport::Cache::FileStore.new('cache')
           end

