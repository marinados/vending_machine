require 'pry'

class Stats
  def initialize(redis)
    @redis = redis
  end

  def add(product)
    overall_sales_stats(product)
    daily_sales_stats(product)
  end

  def retrieve_top_3_products(product_keys)
    data = product_keys.each.with_object({}) do |p, obj|
      obj[p] = @redis.get(p).to_i || 0
    end
    data.sort_by { |(k, v)| v }.reverse.first(3).to_h
  end

  def clear(keys)
    keys.each { |k| @redis.del(k) }
  end

  private

  def overall_sales_stats(product)
    redis_key = product.display_name
    increment_redis_count(redis_key)
  end

  def daily_sales_stats(product)
    redis_key = "#{Date.today.wday}_#{product.display_name}"
    increment_redis_count(redis_key)
  end

  def get_data_from_redis(key)
    @redis.get(key).to_i || 0
  end

  def increment_redis_count(key)
    current_count = get_data_from_redis(key)
    @redis.set(key, current_count + 1)
  end
end
