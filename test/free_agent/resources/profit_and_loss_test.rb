require "test_helper"

class ProfitAndLossResourceTest < Minitest::Test
  def test_summary_returns_items
    client = stub_client do |stubs|
      stubs.get("/v2/accounting/profit_and_loss/summary?from_date=2026-01-01&to_date=2026-03-31") do
        json({ "profit_and_loss_summary" => [ { "category" => "Sales", "credit_value" => "2000.0" } ] })
      end
    end

    item = client.profit_and_loss.summary(from_date: "2026-01-01", to_date: "2026-03-31").first

    assert_equal "Sales", item.category
    assert_equal 2000.0, item.credit_value
  end
end
