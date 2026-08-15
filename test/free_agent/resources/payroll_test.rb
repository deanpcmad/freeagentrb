require "test_helper"

class PayrollResourceTest < Minitest::Test
  def test_list_is_scoped_to_a_tax_year
    client = stub_client do |stubs|
      stubs.get("/v2/payroll/2026") { json({ "periods" => [ { "period" => 1 } ] }) }
    end

    assert_equal 1, client.payroll.list(year: 2026).first.period
  end

  def test_retrieve_returns_a_period
    client = stub_client do |stubs|
      stubs.get("/v2/payroll/2026/1") { json({ "period" => { "period" => 1 } }) }
    end

    assert_equal 1, client.payroll.retrieve(year: 2026, period: 1).period
  end

  def test_mark_payment_as_paid_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/payroll/2026/1/mark_as_paid") { json({}) }
    end

    assert_equal true, client.payroll.mark_payment_as_paid(year: 2026, period: 1)
  end

  def test_mark_payment_as_unpaid_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/payroll/2026/1/mark_as_unpaid") { json({}) }
    end

    assert_equal true, client.payroll.mark_payment_as_unpaid(year: 2026, period: 1)
  end
end
