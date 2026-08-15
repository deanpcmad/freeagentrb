require "test_helper"

class SalesTaxPeriodsResourceTest < Minitest::Test
  def test_list_returns_periods
    client = stub_client do |stubs|
      stubs.get("/v2/sales_tax_periods") { json({ "sales_tax_periods" => [ { "starts_on" => "2026-01-01", "first_rate" => "20.0" } ] }) }
    end

    period = client.sales_tax_periods.list.first

    assert_equal "2026-01-01", period.starts_on
    assert_equal 20.0, period.first_rate
  end

  def test_retrieve_returns_a_period
    client = stub_client do |stubs|
      stubs.get("/v2/sales_tax_periods/1") { json({ "sales_tax_period" => { "starts_on" => "2026-01-01" } }) }
    end

    assert_equal "2026-01-01", client.sales_tax_periods.retrieve(id: 1).starts_on
  end

  def test_create_wraps_payload_in_sales_tax_period_root
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/sales_tax_periods") do |env|
        body = JSON.parse(env.body)
        json({ "sales_tax_period" => { "starts_on" => "2026-01-01" } })
      end
    end

    client.sales_tax_periods.create(starts_on: "2026-01-01", first_rate: "20.0")

    assert_equal({ "sales_tax_period" => { "starts_on" => "2026-01-01", "first_rate" => "20.0" } }, body)
  end

  def test_update_wraps_payload_in_sales_tax_period_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/sales_tax_periods/1") do |env|
        body = JSON.parse(env.body)
        json({ "sales_tax_period" => { "first_rate" => "17.5" } })
      end
    end

    assert_equal 17.5, client.sales_tax_periods.update(id: 1, first_rate: "17.5").first_rate
    assert_equal({ "sales_tax_period" => { "first_rate" => "17.5" } }, body)
  end

  def test_delete_returns_true
    client = stub_client do |stubs|
      stubs.delete("/v2/sales_tax_periods/1") { json({}) }
    end

    assert_equal true, client.sales_tax_periods.delete(id: 1)
  end
end
