require "test_helper"

class StockItemsResourceTest < Minitest::Test
  def test_list_returns_stock_items
    client = stub_client do |stubs|
      stubs.get("/v2/stock_items") { json({ "stock_items" => [ { "description" => "Widget", "opening_quantity" => "10.0" } ] }) }
    end

    item = client.stock_items.list.first

    assert_equal "Widget", item.description
    assert_equal 10.0, item.opening_quantity
  end

  def test_retrieve_returns_a_stock_item
    client = stub_client do |stubs|
      stubs.get("/v2/stock_items/1") { json({ "stock_item" => { "description" => "Widget" } }) }
    end

    assert_equal "Widget", client.stock_items.retrieve(id: 1).description
  end
end
