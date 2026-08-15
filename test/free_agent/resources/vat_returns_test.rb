require "test_helper"

class VatReturnsResourceTest < Minitest::Test
  def test_list_returns_vat_returns
    client = stub_client do |stubs|
      stubs.get("/v2/vat_returns") { json({ "vat_returns" => [ { "period_ends_on" => "2026-03-31" } ] }) }
    end

    assert_equal "2026-03-31", client.vat_returns.list.first.period_ends_on
  end

  def test_retrieve_is_keyed_by_period_end_date
    client = stub_client do |stubs|
      stubs.get("/v2/vat_returns/2026-03-31") { json({ "vat_return" => { "period_ends_on" => "2026-03-31" } }) }
    end

    assert_equal "2026-03-31", client.vat_returns.retrieve(period_ends_on: "2026-03-31").period_ends_on
  end

  def test_mark_as_filed_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/vat_returns/2026-03-31/mark_as_filed") { json({}) }
    end

    assert_equal true, client.vat_returns.mark_as_filed(period_ends_on: "2026-03-31")
  end

  def test_mark_as_unfiled_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/vat_returns/2026-03-31/mark_as_unfiled") { json({}) }
    end

    assert_equal true, client.vat_returns.mark_as_unfiled(period_ends_on: "2026-03-31")
  end

  def test_mark_payment_as_paid_targets_the_payment
    client = stub_client do |stubs|
      stubs.put("/v2/vat_returns/2026-03-31/payments/9/mark_as_paid") { json({}) }
    end

    assert_equal true, client.vat_returns.mark_payment_as_paid(period_ends_on: "2026-03-31", payment_id: 9)
  end

  def test_mark_payment_as_unpaid_targets_the_payment
    client = stub_client do |stubs|
      stubs.put("/v2/vat_returns/2026-03-31/payments/9/mark_as_unpaid") { json({}) }
    end

    assert_equal true, client.vat_returns.mark_payment_as_unpaid(period_ends_on: "2026-03-31", payment_id: 9)
  end
end
