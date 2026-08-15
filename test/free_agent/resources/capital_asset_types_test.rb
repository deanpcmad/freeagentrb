require "test_helper"

class CapitalAssetTypesResourceTest < Minitest::Test
  def test_list_returns_capital_asset_types
    client = stub_client do |stubs|
      stubs.get("/v2/capital_asset_types") { json({ "capital_asset_types" => [ { "name" => "Computer Equipment" } ] }) }
    end

    assert_equal "Computer Equipment", client.capital_asset_types.list.first.name
  end

  def test_retrieve_returns_a_capital_asset_type
    client = stub_client do |stubs|
      stubs.get("/v2/capital_asset_types/1") { json({ "capital_asset_type" => { "name" => "Computer Equipment" } }) }
    end

    assert_equal "Computer Equipment", client.capital_asset_types.retrieve(id: 1).name
  end

  def test_create_wraps_payload_in_capital_asset_type_root
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/capital_asset_types") do |env|
        body = JSON.parse(env.body)
        json({ "capital_asset_type" => { "name" => "Vehicles" } })
      end
    end

    assert_equal "Vehicles", client.capital_asset_types.create(name: "Vehicles").name
    assert_equal({ "capital_asset_type" => { "name" => "Vehicles" } }, body)
  end

  def test_update_wraps_payload_in_capital_asset_type_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/capital_asset_types/1") do |env|
        body = JSON.parse(env.body)
        json({ "capital_asset_type" => { "name" => "Plant" } })
      end
    end

    assert_equal "Plant", client.capital_asset_types.update(id: 1, name: "Plant").name
    assert_equal({ "capital_asset_type" => { "name" => "Plant" } }, body)
  end

  def test_delete_returns_true
    client = stub_client do |stubs|
      stubs.delete("/v2/capital_asset_types/1") { json({}) }
    end

    assert_equal true, client.capital_asset_types.delete(id: 1)
  end
end
