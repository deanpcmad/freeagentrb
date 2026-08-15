require "test_helper"

class BalanceSheetResourceTest < Minitest::Test
  def test_retrieve_returns_balance_sheet_items
    client = stub_client do |stubs|
      stubs.get("/v2/accounting/balance_sheet?period_ends_on=2026-03-31") do
        json({ "balance_sheet" => [ { "name" => "Cash at bank", "closing_balance" => "1500.0" } ] })
      end
    end

    item = client.balance_sheet.retrieve(period_ends_on: "2026-03-31").first

    assert_equal "Cash at bank", item.name
    assert_equal 1500.0, item.closing_balance
  end

  def test_opening_balances_uses_correct_path
    client = stub_client do |stubs|
      stubs.get("/v2/accounting/balance_sheet/opening_balances") { json({ "balance_sheet" => [] }) }
    end

    assert_equal 0, client.balance_sheet.opening_balances.count
  end
end
