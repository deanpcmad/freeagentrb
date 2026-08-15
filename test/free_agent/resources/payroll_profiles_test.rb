require "test_helper"

class PayrollProfilesResourceTest < Minitest::Test
  def test_list_is_scoped_to_a_tax_year
    client = stub_client do |stubs|
      stubs.get("/v2/payroll_profiles/2026") { json({ "profiles" => [ { "basic_pay" => "2000.0" } ] }) }
    end

    assert_equal 2000.0, client.payroll_profiles.list(year: 2026).first.basic_pay
  end

  def test_list_can_be_filtered_by_user
    client = stub_client do |stubs|
      stubs.get("/v2/payroll_profiles/2026?user=https://api.freeagent.com/v2/users/1") { json({ "profiles" => [] }) }
    end

    assert_equal 0, client.payroll_profiles.list(year: 2026, user: "https://api.freeagent.com/v2/users/1").count
  end
end
