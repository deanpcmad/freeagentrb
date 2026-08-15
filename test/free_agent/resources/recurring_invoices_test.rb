require "test_helper"

class RecurringInvoicesResourceTest < Minitest::Test
  def test_list_returns_recurring_invoices
    client = stub_client do |stubs|
      stubs.get("/v2/recurring_invoices") { json({ "recurring_invoices" => [ { "reference" => "001", "total_value" => "100.0" } ] }) }
    end

    invoices = client.recurring_invoices.list

    assert_equal 1, invoices.count
    assert_equal "001", invoices.first.reference
    assert_equal 100.0, invoices.first.total_value
  end

  def test_list_for_contact_filters_by_contact
    client = stub_client do |stubs|
      stubs.get("/v2/recurring_invoices?contact=https://api.freeagent.com/v2/contacts/1") do
        json({ "recurring_invoices" => [] })
      end
    end

    assert_equal 0, client.recurring_invoices.list_for_contact(contact: "https://api.freeagent.com/v2/contacts/1").count
  end

  def test_retrieve_returns_a_recurring_invoice
    client = stub_client do |stubs|
      stubs.get("/v2/recurring_invoices/1") { json({ "recurring_invoice" => { "reference" => "001" } }) }
    end

    assert_equal "001", client.recurring_invoices.retrieve(id: 1).reference
  end
end
