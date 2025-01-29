$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "freeagentrb"
require "minitest/autorun"
require "faraday"
require "json"
require "vcr"
require "dotenv/load"

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :faraday

  config.filter_sensitive_data("<AUTHORIZATION>") { ENV["FREEAGENT_ACCESS_TOKEN"] }
end

def setup_client
  @client ||= FreeAgent::Client.new(access_token: ENV["FREEAGENT_ACCESS_TOKEN"], sandbox: true)
end

class Minitest::Test
  def setup
    VCR.insert_cassette(name)
  end

  def teardown
    VCR.eject_cassette
  end
end
