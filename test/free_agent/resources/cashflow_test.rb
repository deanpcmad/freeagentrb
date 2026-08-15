require "test_helper"

class CashflowResourceTest < Minitest::Test
  def test_retrieve_returns_cashflow_items
    client = stub_client do |stubs|
      stubs.get("/v2/cashflow") { json({ "cashflow" => [ { "period" => "2026-01", "money_in" => "500.0" } ] }) }
    end

    item = client.cashflow.retrieve.first

    assert_equal "2026-01", item.period
    assert_equal 500.0, item.money_in
  end
end
