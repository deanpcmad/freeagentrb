require "test_helper"

class CreditNoteReconciliationsResourceTest < Minitest::Test
  def test_create_wraps_payload_in_credit_note_reconciliation_root
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/credit_note_reconciliations") do |env|
        body = JSON.parse(env.body)
        json({ "credit_note_reconciliation" => { "value" => "25.0" } })
      end
    end

    reconciliation = client.credit_note_reconciliations.create(
      credit_note: "https://api.freeagent.com/v2/credit_notes/1",
      invoice: "https://api.freeagent.com/v2/invoices/2",
      value: "25.0"
    )

    assert_equal 25.0, reconciliation.value
    assert_equal({ "credit_note_reconciliation" => {
      "credit_note" => "https://api.freeagent.com/v2/credit_notes/1",
      "invoice" => "https://api.freeagent.com/v2/invoices/2",
      "value" => "25.0"
    } }, body)
  end

  def test_list_returns_reconciliations
    client = stub_client do |stubs|
      stubs.get("/v2/credit_note_reconciliations") { json({ "credit_note_reconciliations" => [ { "value" => "1.0" } ] }) }
    end

    assert_equal 1, client.credit_note_reconciliations.list.count
  end

  def test_retrieve_returns_a_reconciliation
    client = stub_client do |stubs|
      stubs.get("/v2/credit_note_reconciliations/1") { json({ "credit_note_reconciliation" => { "value" => "1.0" } }) }
    end

    assert_equal 1.0, client.credit_note_reconciliations.retrieve(id: 1).value
  end

  def test_update_wraps_payload_in_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/credit_note_reconciliations/1") do |env|
        body = JSON.parse(env.body)
        json({ "credit_note_reconciliation" => { "value" => "2.0" } })
      end
    end

    assert_equal 2.0, client.credit_note_reconciliations.update(id: 1, value: "2.0").value
    assert_equal({ "credit_note_reconciliation" => { "value" => "2.0" } }, body)
  end

  def test_delete_returns_true
    client = stub_client do |stubs|
      stubs.delete("/v2/credit_note_reconciliations/1") { json({}) }
    end

    assert_equal true, client.credit_note_reconciliations.delete(id: 1)
  end
end
