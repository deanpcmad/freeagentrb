require "test_helper"

class EmailAddressesResourceTest < Minitest::Test
  def test_list_returns_an_array_of_addresses
    client = stub_client do |stubs|
      stubs.get("/v2/email_addresses") { json({ "email_addresses" => [ "me@example.com", "billing@example.com" ] }) }
    end

    assert_equal [ "me@example.com", "billing@example.com" ], client.email_addresses.list
  end
end
