require "test_helper"

class CorporationTaxReturnsResourceTest < Minitest::Test
  def test_list_returns_corporation_tax_returns
    client = stub_client do |stubs|
      stubs.get("/v2/corporation_tax_returns") { json({ "corporation_tax_returns" => [ { "period_ends_on" => "2026-03-31" } ] }) }
    end

    assert_equal "2026-03-31", client.corporation_tax_returns.list.first.period_ends_on
  end

  def test_retrieve_is_keyed_by_period_end_date
    client = stub_client do |stubs|
      stubs.get("/v2/corporation_tax_returns/2026-03-31") do
        json({ "corporation_tax_return" => { "period_ends_on" => "2026-03-31" } })
      end
    end

    assert_equal "2026-03-31", client.corporation_tax_returns.retrieve(period_ends_on: "2026-03-31").period_ends_on
  end

  def test_transitions_use_correct_paths
    client = stub_client do |stubs|
      stubs.put("/v2/corporation_tax_returns/2026-03-31/mark_as_filed") { json({}) }
      stubs.put("/v2/corporation_tax_returns/2026-03-31/mark_as_unfiled") { json({}) }
      stubs.put("/v2/corporation_tax_returns/2026-03-31/mark_as_paid") { json({}) }
      stubs.put("/v2/corporation_tax_returns/2026-03-31/mark_as_unpaid") { json({}) }
    end

    assert_equal true, client.corporation_tax_returns.mark_as_filed(period_ends_on: "2026-03-31")
    assert_equal true, client.corporation_tax_returns.mark_as_unfiled(period_ends_on: "2026-03-31")
    assert_equal true, client.corporation_tax_returns.mark_as_paid(period_ends_on: "2026-03-31")
    assert_equal true, client.corporation_tax_returns.mark_as_unpaid(period_ends_on: "2026-03-31")
  end
end
