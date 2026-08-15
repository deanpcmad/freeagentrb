require "test_helper"

class HirePurchasesResourceTest < Minitest::Test
  def test_list_returns_hire_purchases
    client = stub_client do |stubs|
      stubs.get("/v2/hire_purchases") { json({ "hire_purchases" => [ { "description" => "Van", "asset_value" => "15000.0" } ] }) }
    end

    hire_purchase = client.hire_purchases.list.first

    assert_equal "Van", hire_purchase.description
    assert_equal 15000.0, hire_purchase.asset_value
  end

  def test_retrieve_returns_a_hire_purchase
    client = stub_client do |stubs|
      stubs.get("/v2/hire_purchases/1") { json({ "hire_purchase" => { "description" => "Van" } }) }
    end

    assert_equal "Van", client.hire_purchases.retrieve(id: 1).description
  end
end
