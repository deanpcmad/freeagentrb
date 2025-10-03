require "test_helper"

class OAuthTest < Minitest::Test
  def test_oauth_initialization
    oauth = FreeAgent::OAuth.new(client_id: "test_id", client_secret: "test_secret")

    assert_equal "test_id", oauth.client_id
    assert_equal "test_secret", oauth.client_secret
  end

  def test_oauth_sandbox
    oauth_sandbox = FreeAgent::OAuth.new(sandbox: true, client_id: "test_id", client_secret: "test_secret")

    assert_equal "https://api.sandbox.freeagent.com/v2/", oauth_sandbox.instance_variable_get(:@base_url)
  end

  def test_oauth_production
    oauth_sandbox = FreeAgent::OAuth.new(sandbox: false, client_id: "test_id", client_secret: "test_secret")

    assert_equal "https://api.freeagent.com/v2/", oauth_sandbox.instance_variable_get(:@base_url)
  end
end
