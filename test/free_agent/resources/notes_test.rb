require "test_helper"

class NotesResourceTest < Minitest::Test
  def test_list_for_contact_sends_the_parent_as_a_query_param
    client = stub_client do |stubs|
      stubs.get("/v2/notes?contact=https://api.freeagent.com/v2/contacts/1") do
        json({ "notes" => [ { "note" => "Called them" } ] })
      end
    end

    notes = client.notes.list_for_contact(contact: "https://api.freeagent.com/v2/contacts/1")

    assert_equal "Called them", notes.first.note
  end

  def test_list_for_project_sends_the_parent_as_a_query_param
    client = stub_client do |stubs|
      stubs.get("/v2/notes?project=https://api.freeagent.com/v2/projects/1") { json({ "notes" => [] }) }
    end

    assert_equal 0, client.notes.list_for_project(project: "https://api.freeagent.com/v2/projects/1").count
  end

  def test_create_puts_the_parent_in_the_query_string_not_the_body
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/notes?contact=https://api.freeagent.com/v2/contacts/1") do |env|
        body = JSON.parse(env.body)
        json({ "note" => { "note" => "Called them" } })
      end
    end

    note = client.notes.create(note: "Called them", contact: "https://api.freeagent.com/v2/contacts/1")

    assert_equal "Called them", note.note
    assert_equal({ "note" => { "note" => "Called them" } }, body)
  end

  def test_retrieve_returns_a_note
    client = stub_client do |stubs|
      stubs.get("/v2/notes/1") { json({ "note" => { "note" => "Called them" } }) }
    end

    assert_equal "Called them", client.notes.retrieve(id: 1).note
  end

  def test_update_wraps_payload_in_note_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/notes/1") do |env|
        body = JSON.parse(env.body)
        json({ "note" => { "note" => "Updated" } })
      end
    end

    assert_equal "Updated", client.notes.update(id: 1, note: "Updated").note
    assert_equal({ "note" => { "note" => "Updated" } }, body)
  end

  def test_delete_returns_true
    client = stub_client do |stubs|
      stubs.delete("/v2/notes/1") { json({}) }
    end

    assert_equal true, client.notes.delete(id: 1)
  end
end
