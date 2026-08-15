require "test_helper"

class JournalSetsResourceTest < Minitest::Test
  def test_list_returns_journal_sets
    client = stub_client do |stubs|
      stubs.get("/v2/journal_sets") { json({ "journal_sets" => [ { "description" => "Adjustment" } ] }) }
    end

    assert_equal "Adjustment", client.journal_sets.list.first.description
  end

  def test_opening_balances_uses_correct_path
    client = stub_client do |stubs|
      stubs.get("/v2/journal_sets/opening_balances") { json({ "journal_sets" => [ { "description" => "Opening" } ] }) }
    end

    assert_equal "Opening", client.journal_sets.opening_balances.first.description
  end

  def test_retrieve_returns_a_journal_set
    client = stub_client do |stubs|
      stubs.get("/v2/journal_sets/1") { json({ "journal_set" => { "description" => "Adjustment" } }) }
    end

    assert_equal "Adjustment", client.journal_sets.retrieve(id: 1).description
  end

  def test_create_sends_journal_entries
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/journal_sets") do |env|
        body = JSON.parse(env.body)
        json({ "journal_set" => { "description" => "Adjustment" } })
      end
    end

    entries = [ { category: "https://api.freeagent.com/v2/categories/285", debit_value: "10.0", description: "Stationery" } ]
    client.journal_sets.create(dated_on: "2026-08-15", description: "Adjustment", journal_entries: entries)

    assert_equal "2026-08-15", body["journal_set"]["dated_on"]
    assert_equal 1, body["journal_set"]["journal_entries"].size
    assert_equal "10.0", body["journal_set"]["journal_entries"][0]["debit_value"]
  end

  def test_update_wraps_payload_in_journal_set_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/journal_sets/1") do |env|
        body = JSON.parse(env.body)
        json({ "journal_set" => { "description" => "Updated" } })
      end
    end

    assert_equal "Updated", client.journal_sets.update(id: 1, description: "Updated").description
    assert_equal({ "journal_set" => { "description" => "Updated" } }, body)
  end

  def test_delete_returns_true
    client = stub_client do |stubs|
      stubs.delete("/v2/journal_sets/1") { json({}) }
    end

    assert_equal true, client.journal_sets.delete(id: 1)
  end
end
