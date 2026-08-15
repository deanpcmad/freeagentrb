require "test_helper"

class FinalAccountsReportsResourceTest < Minitest::Test
  def test_list_returns_reports
    client = stub_client do |stubs|
      stubs.get("/v2/final_accounts_reports") { json({ "final_accounts_reports" => [ { "period_ends_on" => "2026-03-31" } ] }) }
    end

    assert_equal "2026-03-31", client.final_accounts_reports.list.first.period_ends_on
  end

  def test_retrieve_is_keyed_by_period_end_date
    client = stub_client do |stubs|
      stubs.get("/v2/final_accounts_reports/2026-03-31") do
        json({ "final_accounts_report" => { "period_ends_on" => "2026-03-31" } })
      end
    end

    assert_equal "2026-03-31", client.final_accounts_reports.retrieve(period_ends_on: "2026-03-31").period_ends_on
  end

  def test_mark_as_filed_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/final_accounts_reports/2026-03-31/mark_as_filed") { json({}) }
    end

    assert_equal true, client.final_accounts_reports.mark_as_filed(period_ends_on: "2026-03-31")
  end

  def test_mark_as_unfiled_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/final_accounts_reports/2026-03-31/mark_as_unfiled") { json({}) }
    end

    assert_equal true, client.final_accounts_reports.mark_as_unfiled(period_ends_on: "2026-03-31")
  end
end
