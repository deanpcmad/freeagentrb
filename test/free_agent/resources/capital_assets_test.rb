require "test_helper"

class CapitalAssetsResourceTest < Minitest::Test
  def test_list_returns_capital_assets
    client = stub_client do |stubs|
      stubs.get("/v2/capital_assets") { json({ "capital_assets" => [ { "description" => "Laptop", "purchase_value" => "1200.0" } ] }) }
    end

    asset = client.capital_assets.list.first

    assert_equal "Laptop", asset.description
    assert_equal 1200.0, asset.purchase_value
  end

  def test_list_passes_include_history
    client = stub_client do |stubs|
      stubs.get("/v2/capital_assets?include_history=true") { json({ "capital_assets" => [] }) }
    end

    assert_equal 0, client.capital_assets.list(include_history: true).count
  end

  def test_retrieve_returns_a_capital_asset
    client = stub_client do |stubs|
      stubs.get("/v2/capital_assets/1") { json({ "capital_asset" => { "description" => "Laptop" } }) }
    end

    assert_equal "Laptop", client.capital_assets.retrieve(id: 1).description
  end
end
