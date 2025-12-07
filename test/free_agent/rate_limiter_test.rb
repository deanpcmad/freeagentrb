require "test_helper"

class FreeAgent::RateLimiterTest < Minitest::Test
  def setup
    @rate_limiter = FreeAgent::RateLimiter.new
  end

  def test_initial_state
    assert_nil @rate_limiter.retry_after
    assert_nil @rate_limiter.rate_limited_at
    refute @rate_limiter.rate_limited?
    assert_equal "Not rate limited", @rate_limiter.status
  end

  def test_update_with_retry_after_header
    headers = { "retry-after" => "60" }
    @rate_limiter.update(headers)

    assert_equal 60, @rate_limiter.retry_after
    refute_nil @rate_limiter.rate_limited_at
    assert @rate_limiter.rate_limited?
  end

  def test_reset_in_calculation
    headers = { "retry-after" => "60" }
    @rate_limiter.update(headers)

    reset_in = @rate_limiter.reset_in
    assert reset_in > 0
    assert reset_in <= 60
  end

  def test_rate_limited_expires
    headers = { "retry-after" => "1" }
    @rate_limiter.update(headers)

    assert @rate_limiter.rate_limited?

    sleep 2

    refute @rate_limiter.rate_limited?
  end

  def test_reset
    headers = { "retry-after" => "60" }
    @rate_limiter.update(headers)

    @rate_limiter.reset

    assert_nil @rate_limiter.retry_after
    assert_nil @rate_limiter.rate_limited_at
    refute @rate_limiter.rate_limited?
  end

  def test_status_when_rate_limited
    headers = { "retry-after" => "60" }
    @rate_limiter.update(headers)

    status = @rate_limiter.status
    assert_match(/Rate limited/, status)
    assert_match(/Retry in/, status)
  end

  def test_update_with_no_headers
    @rate_limiter.update(nil)

    assert_nil @rate_limiter.retry_after
    refute @rate_limiter.rate_limited?
  end

  def test_update_with_empty_headers
    @rate_limiter.update({})

    assert_nil @rate_limiter.retry_after
    refute @rate_limiter.rate_limited?
  end
end
