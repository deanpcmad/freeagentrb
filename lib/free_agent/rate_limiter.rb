module FreeAgent
  class RateLimiter
    # FreeAgent API rate limit header
    RETRY_AFTER_HEADER = "retry-after".freeze

    attr_reader :retry_after, :rate_limited_at, :logger

    def initialize(logger: nil)
      @retry_after = nil
      @rate_limited_at = nil
      @logger = logger
    end

    # Update rate limit info from response headers (called on 429 responses)
    def update(response_headers)
      return unless response_headers

      @retry_after = response_headers[RETRY_AFTER_HEADER]&.to_i
      @rate_limited_at = Time.now if @retry_after
    end

    # Check if currently rate limited
    def rate_limited?
      return false if retry_after.nil? || rate_limited_at.nil?

      # Check if we're still within the retry-after window
      (Time.now - rate_limited_at) < retry_after
    end

    # Get seconds until rate limit resets
    def reset_in
      return nil if retry_after.nil? || rate_limited_at.nil?

      seconds = retry_after - (Time.now - rate_limited_at)
      [ seconds, 0 ].max.ceil  # Ensure non-negative and round up
    end

    # Wait if rate limited
    def wait_if_rate_limited
      return unless rate_limited?

      wait_seconds = reset_in
      return if wait_seconds.nil? || wait_seconds.zero?

      if logger
        logger.warn("Rate limited. Waiting #{wait_seconds} seconds before retrying")
      end

      sleep(wait_seconds)
    end

    # Reset rate limit tracking
    def reset
      @retry_after = nil
      @rate_limited_at = nil
    end

    # Get formatted status string
    def status
      if rate_limited?
        "Rate limited. Retry in #{reset_in} seconds"
      else
        "Not rate limited"
      end
    end
  end
end
