require "test_helper"

class EstimatesResourceTest < Minitest::Test
  def test_update_wraps_payload_in_estimate_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/estimates/1") do |env|
        body = JSON.parse(env.body)
        [ 200, { "Content-Type" => "application/json" }, JSON.dump({ "estimate" => { "reference" => "002" } }) ]
      end
    end

    estimate = client.estimates.update(id: 1, reference: "002")

    assert_equal({ "estimate" => { "reference" => "002" } }, body)
    assert_equal "002", estimate.reference
  end

  def test_mark_as_sent_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/estimates/1/transitions/mark_as_sent") { [ 200, { "Content-Type" => "application/json" }, "{}" ] }
    end

    assert_equal true, client.estimates.mark_as_sent(id: 1)
  end

  def test_mark_as_draft_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/estimates/1/transitions/mark_as_draft") { [ 200, { "Content-Type" => "application/json" }, "{}" ] }
    end

    assert_equal true, client.estimates.mark_as_draft(id: 1)
  end

  def test_mark_as_approved_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/estimates/1/transitions/mark_as_approved") { [ 200, { "Content-Type" => "application/json" }, "{}" ] }
    end

    assert_equal true, client.estimates.mark_as_approved(id: 1)
  end

  def test_mark_as_rejected_uses_correct_path
    client = stub_client do |stubs|
      stubs.put("/v2/estimates/1/transitions/mark_as_rejected") { [ 200, { "Content-Type" => "application/json" }, "{}" ] }
    end

    assert_equal true, client.estimates.mark_as_rejected(id: 1)
  end
end
