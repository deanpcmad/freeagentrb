require "test_helper"

class SelfAssessmentReturnsResourceTest < Minitest::Test
  def test_list_is_nested_under_a_user
    client = stub_client do |stubs|
      stubs.get("/v2/users/5/self_assessment_returns") do
        json({ "self_assessment_returns" => [ { "period_ends_on" => "2026-04-05" } ] })
      end
    end

    assert_equal "2026-04-05", client.self_assessment_returns.list(user_id: 5).first.period_ends_on
  end

  def test_retrieve_is_keyed_by_period_end_date
    client = stub_client do |stubs|
      stubs.get("/v2/users/5/self_assessment_returns/2026-04-05") do
        json({ "self_assessment_return" => { "period_ends_on" => "2026-04-05" } })
      end
    end

    assert_equal "2026-04-05", client.self_assessment_returns.retrieve(user_id: 5, period_ends_on: "2026-04-05").period_ends_on
  end

  def test_transitions_use_correct_paths
    client = stub_client do |stubs|
      stubs.put("/v2/users/5/self_assessment_returns/2026-04-05/mark_as_filed") { json({}) }
      stubs.put("/v2/users/5/self_assessment_returns/2026-04-05/mark_as_unfiled") { json({}) }
      stubs.put("/v2/users/5/self_assessment_returns/2026-04-05/mark_as_paid") { json({}) }
      stubs.put("/v2/users/5/self_assessment_returns/2026-04-05/mark_as_unpaid") { json({}) }
    end

    assert_equal true, client.self_assessment_returns.mark_as_filed(user_id: 5, period_ends_on: "2026-04-05")
    assert_equal true, client.self_assessment_returns.mark_as_unfiled(user_id: 5, period_ends_on: "2026-04-05")
    assert_equal true, client.self_assessment_returns.mark_as_paid(user_id: 5, period_ends_on: "2026-04-05")
    assert_equal true, client.self_assessment_returns.mark_as_unpaid(user_id: 5, period_ends_on: "2026-04-05")
  end
end
