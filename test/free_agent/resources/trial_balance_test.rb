require "test_helper"

class TrialBalanceResourceTest < Minitest::Test
  def test_summary_returns_items
    client = stub_client do |stubs|
      stubs.get("/v2/accounting/trial_balance/summary") do
        json({ "trial_balance_summary" => [ { "name" => "Sales", "credit_value" => "2000.0" } ] })
      end
    end

    assert_equal 2000.0, client.trial_balance.summary.first.credit_value
  end

  def test_opening_balances_uses_correct_path
    client = stub_client do |stubs|
      stubs.get("/v2/accounting/trial_balance/opening_balances") { json({ "trial_balance_opening_balances" => [] }) }
    end

    assert_equal 0, client.trial_balance.opening_balances.count
  end
end
