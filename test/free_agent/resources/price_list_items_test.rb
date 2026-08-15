require "test_helper"

class PriceListItemsResourceTest < Minitest::Test
  def test_create_wraps_payload_in_price_list_item_root
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/price_list_items") do |env|
        body = JSON.parse(env.body)
        json({ "price_list_item" => { "code" => "A1", "price" => "9.99" } })
      end
    end

    item = client.price_list_items.create(code: "A1", quantity: 1, item_type: "Hours", description: "Consulting", price: "9.99")

    assert_equal({ "price_list_item" => { "code" => "A1", "quantity" => 1, "item_type" => "Hours", "description" => "Consulting", "price" => "9.99" } }, body)
    assert_equal 9.99, item.price
  end

  def test_list_returns_price_list_items
    client = stub_client do |stubs|
      stubs.get("/v2/price_list_items") { json({ "price_list_items" => [ { "code" => "A1" } ] }) }
    end

    assert_equal "A1", client.price_list_items.list.first.code
  end

  def test_retrieve_returns_a_price_list_item
    client = stub_client do |stubs|
      stubs.get("/v2/price_list_items/1") { json({ "price_list_item" => { "code" => "A1" } }) }
    end

    assert_equal "A1", client.price_list_items.retrieve(id: 1).code
  end

  def test_update_wraps_payload_in_price_list_item_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/price_list_items/1") do |env|
        body = JSON.parse(env.body)
        json({ "price_list_item" => { "code" => "A2" } })
      end
    end

    assert_equal "A2", client.price_list_items.update(id: 1, code: "A2").code
    assert_equal({ "price_list_item" => { "code" => "A2" } }, body)
  end

  def test_delete_returns_true
    client = stub_client do |stubs|
      stubs.delete("/v2/price_list_items/1") { json({}) }
    end

    assert_equal true, client.price_list_items.delete(id: 1)
  end
end
