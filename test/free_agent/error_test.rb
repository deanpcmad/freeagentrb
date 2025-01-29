class ErrorTest < Minitest::Test
  def test_bad_request_error
    error = FreeAgent::ErrorFactory.create(
      { "error" => 123, "message" => "FreeAgent error message" },
      400
    )

    assert_equal "Error 400: Your request was malformed. 'FreeAgent error message'", error.message
  end

  def test_authentication_missing_error
    error = FreeAgent::ErrorFactory.create(
      { "error": {} },
      401
    )

    assert_equal "Error 401: You did not supply valid authentication credentials.", error.message
  end

  def test_freeagent_error_generator_message
    error = FreeAgent::ErrorGenerator.new({ "error" => 123, "message" => "FreeAgent error message" }, 409)

    assert_equal "FreeAgent error message", error.freeagent_error_message
  end

  def test_freeagent_error_message
    error = FreeAgent::Error.new("Connection failed")

    assert_equal "Connection failed", error.message
  end
end
