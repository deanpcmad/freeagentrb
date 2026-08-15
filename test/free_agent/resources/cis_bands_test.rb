require "test_helper"

class CisBandsResourceTest < Minitest::Test
  def test_list_returns_cis_bands
    client = stub_client do |stubs|
      stubs.get("/v2/cis_bands") { json({ "cis_bands" => [ { "name" => "CIS Gross" } ] }) }
    end

    assert_equal "CIS Gross", client.cis_bands.list.first.name
  end
end
