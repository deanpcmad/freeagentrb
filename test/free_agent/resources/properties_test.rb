require "test_helper"

class PropertiesResourceTest < Minitest::Test
  def test_list_returns_properties
    client = stub_client do |stubs|
      stubs.get("/v2/properties") { json({ "properties" => [ { "name" => "12 High Street" } ] }) }
    end

    assert_equal "12 High Street", client.properties.list.first.name
  end

  def test_retrieve_returns_a_property
    client = stub_client do |stubs|
      stubs.get("/v2/properties/1") { json({ "property" => { "name" => "12 High Street" } }) }
    end

    assert_equal "12 High Street", client.properties.retrieve(id: 1).name
  end

  def test_create_wraps_payload_in_property_root
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/properties") do |env|
        body = JSON.parse(env.body)
        json({ "property" => { "name" => "12 High Street" } })
      end
    end

    assert_equal "12 High Street", client.properties.create(name: "12 High Street").name
    assert_equal({ "property" => { "name" => "12 High Street" } }, body)
  end

  def test_update_wraps_payload_in_property_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/properties/1") do |env|
        body = JSON.parse(env.body)
        json({ "property" => { "name" => "14 High Street" } })
      end
    end

    assert_equal "14 High Street", client.properties.update(id: 1, name: "14 High Street").name
    assert_equal({ "property" => { "name" => "14 High Street" } }, body)
  end

  def test_delete_returns_true
    client = stub_client do |stubs|
      stubs.delete("/v2/properties/1") { json({}) }
    end

    assert_equal true, client.properties.delete(id: 1)
  end
end
