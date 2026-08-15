require "test_helper"

class BankFeedsResourceTest < Minitest::Test
  def test_list_returns_bank_feeds
    client = stub_client do |stubs|
      stubs.get("/v2/bank_feeds") { json({ "bank_feeds" => [ { "status" => "active" } ] }) }
    end

    assert_equal "active", client.bank_feeds.list.first.status
  end

  def test_retrieve_returns_a_bank_feed
    client = stub_client do |stubs|
      stubs.get("/v2/bank_feeds/1") { json({ "bank_feed" => { "status" => "active" } }) }
    end

    assert_equal "active", client.bank_feeds.retrieve(id: 1).status
  end
end
