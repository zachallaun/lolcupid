class RateLimiter
  def initialize(interval:, max_in_interval:)
    @interval = interval
    @max_in_interval = max_in_interval
    @storage = Hash.new { |h, k| h[k] = [] }
  end

  def wait(key)
    now = now_ms
    clear_before = now - @interval

    limit_set = @storage[key] = @storage[key].select { |t| t > clear_before }

    too_many_in_interval = limit_set.length >= @max_in_interval
    time_since_last_request = now - (limit_set.last || 0)

    if too_many_in_interval
      wait = (limit_set[0].to_f - now + @interval) / 1000
      sleep(wait)
    end

    @storage[key] << now
    wait
  end

  private

  def now_ms
    (Time.now.to_f * 1000).floor
  end
end
