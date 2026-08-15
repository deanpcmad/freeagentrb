require "test_helper"

class EstimateItemsResourceTest < Minitest::Test
  ESTIMATE_ITEM = {
    "url" => "https://api.freeagent.com/v2/estimate_items/1",
    "position" => 1,
    "item_type" => "Hours",
    "quantity" => "10.0",
    "price" => "100.0",
    "description" => "Consultancy"
  }.freeze

  def test_create_sends_estimate_and_item_as_separate_roots
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/estimate_items") do |env|
        body = JSON.parse(env.body)
        json({ "estimate_item" => ESTIMATE_ITEM }, status: 201)
      end
    end

    item = client.estimate_items.create(
      estimate: "https://api.freeagent.com/v2/estimates/1",
      item_type: "Hours",
      quantity: "10.0",
      price: "100.0",
      description: "Consultancy"
    )

    assert_equal "https://api.freeagent.com/v2/estimates/1", body["estimate"]
    assert_equal "Consultancy", body["estimate_item"]["description"]
    assert_equal "Hours", body["estimate_item"]["item_type"]

    # The estimate URL is a sibling of estimate_item, not nested inside it
    refute body["estimate_item"].key?("estimate")

    assert_equal FreeAgent::EstimateItem, item.class
  end

  def test_update_wraps_payload_in_estimate_item_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/estimate_items/1") do |env|
        body = JSON.parse(env.body)
        json({ "estimate_item" => ESTIMATE_ITEM.merge("description" => "Updated") })
      end
    end

    item = client.estimate_items.update(id: 1, description: "Updated")

    assert_equal({ "estimate_item" => { "description" => "Updated" } }, body)
    assert_equal "Updated", item.description
  end

  def test_delete
    client = stub_client do |stubs|
      stubs.delete("/v2/estimate_items/1") { json({}) }
    end

    assert_equal true, client.estimate_items.delete(id: 1)
  end
end
