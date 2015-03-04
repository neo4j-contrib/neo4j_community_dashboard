require 'active_support'

ApiCache = if ENV['REDISCLOUD_URL']
             require 'redis-activesupport'
             ActiveSupport::Cache::RedisStore.new(ENV['REDISCLOUD_URL'], expires_in: 3.hours)
           else
             ActiveSupport::Cache::FileStore.new('cache', expires_in: 3.hours)
           end

