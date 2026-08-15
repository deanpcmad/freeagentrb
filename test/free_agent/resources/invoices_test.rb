require "test_helper"

class InvoicesResourceTest < Minitest::Test
  INVOICE = {
    "url" => "https://api.freeagent.com/v2/invoices/1",
    "contact" => "https://api.freeagent.com/v2/contacts/2",
    "dated_on" => "2011-08-29",
    "due_on" => "2011-09-28",
    "reference" => "001",
    "currency" => "GBP",
    "total_value" => "200.0",
    "net_value" => "0.0",
    "exchange_rate" => "1.0",
    "paid_value" => "50.0",
    "due_value" => "150.0",
    "status" => "Open",
    "payment_terms_in_days" => 30,
    "ec_status" => "EC Goods",
    "payment_methods" => { "paypal" => true, "stripe" => false },
    "invoice_items" => [
      { "description" => "Test InvoiceItem", "item_type" => "Hours", "price" => "0.0", "quantity" => "0.0" }
    ]
  }.freeze

  def test_list
    client = stub_client do |stubs|
      stubs.get("/v2/invoices") { json({ "invoices" => [ INVOICE ] }) }
    end

    invoices = client.invoices.list

    assert_equal FreeAgent::Collection, invoices.class
    assert_equal FreeAgent::Invoice, invoices.first.class
    assert_equal "001", invoices.first.reference
    assert_equal "Open", invoices.first.status
  end

  def test_list_for_contact
    client = stub_client do |stubs|
      stubs.get("/v2/invoices?contact=https://api.freeagent.com/v2/contacts/2") do
        json({ "invoices" => [ INVOICE ] })
      end
    end

    invoices = client.invoices.list_for_contact(contact: "https://api.freeagent.com/v2/contacts/2")

    assert_equal 1, invoices.count
  end

  def test_retrieve
    client = stub_client do |stubs|
      stubs.get("/v2/invoices/1") { json({ "invoice" => INVOICE }) }
    end

    invoice = client.invoices.retrieve(id: 1)

    assert_equal FreeAgent::Invoice, invoice.class

    # Nested objects and arrays are exposed too
    assert_equal true, invoice.payment_methods.paypal
    assert_equal "Test InvoiceItem", invoice.invoice_items.first.description
  end

  def test_retrieve_coerces_monetary_values_to_floats
    client = stub_client do |stubs|
      stubs.get("/v2/invoices/1") { json({ "invoice" => INVOICE }) }
    end

    invoice = client.invoices.retrieve(id: 1)

    # Invoice converts these four from the strings the API returns
    assert_equal 200.0, invoice.total_value
    assert_equal 50.0, invoice.paid_value
    assert_equal 150.0, invoice.due_value
    assert_equal 0.0, invoice.net_value

    # Other decimal-ish values are left as strings
    assert_equal "1.0", invoice.exchange_rate
  end

  def test_retrieve_pdf_returns_base64_content
    client = stub_client do |stubs|
      stubs.get("/v2/invoices/1/pdf") { json({ "pdf" => { "content" => "JVBERi0xLjQK" } }) }
    end

    assert_equal "JVBERi0xLjQK", client.invoices.retrieve_pdf(id: 1)
  end

  def test_create_wraps_payload_in_invoice_root
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/invoices") do |env|
        body = JSON.parse(env.body)
        json({ "invoice" => INVOICE }, status: 201)
      end
    end

    invoice = client.invoices.create(
      contact: "https://api.freeagent.com/v2/contacts/2",
      dated_on: "2011-08-29",
      payment_terms_in_days: 30,
      invoice_items: [ { "description" => "Consultancy", "item_type" => "Hours", "price" => "100.0", "quantity" => "10.0" } ]
    )

    assert_equal "https://api.freeagent.com/v2/contacts/2", body["invoice"]["contact"]
    assert_equal 30, body["invoice"]["payment_terms_in_days"]
    assert_equal "Consultancy", body["invoice"]["invoice_items"].first["description"]
    assert_equal "001", invoice.reference
  end

  def test_create_defaults_payment_terms_to_zero
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/invoices") do |env|
        body = JSON.parse(env.body)
        json({ "invoice" => INVOICE }, status: 201)
      end
    end

    client.invoices.create(contact: "https://api.freeagent.com/v2/contacts/2", dated_on: "2011-08-29")

    assert_equal 0, body["invoice"]["payment_terms_in_days"]
  end

  def test_update_wraps_payload_in_invoice_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/invoices/1") do |env|
        body = JSON.parse(env.body)
        json({ "invoice" => INVOICE })
      end
    end

    client.invoices.update(id: 1, reference: "002")

    assert_equal({ "invoice" => { "reference" => "002" } }, body)
  end

  def test_delete
    client = stub_client do |stubs|
      stubs.delete("/v2/invoices/1") { json({}) }
    end

    assert_equal true, client.invoices.delete(id: 1)
  end

  def test_duplicate
    client = stub_client do |stubs|
      stubs.post("/v2/invoices/1/duplicate") { json({ "invoice" => INVOICE }, status: 201) }
    end

    assert_equal FreeAgent::Invoice, client.invoices.duplicate(id: 1).class
  end

  def test_email_nests_attributes_under_email
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/invoices/1/send_email") do |env|
        body = JSON.parse(env.body)
        json({})
      end
    end

    client.invoices.email(id: 1, to: "someone@example.com", subject: "Your invoice")

    assert_equal "someone@example.com", body["invoice"]["email"]["to"]
    assert_equal "Your invoice", body["invoice"]["email"]["subject"]
  end

  def test_transitions_use_correct_paths
    {
      mark_as_sent: "mark_as_sent",
      mark_as_scheduled: "mark_as_scheduled",
      mark_as_draft: "mark_as_draft",
      mark_as_cancelled: "mark_as_cancelled",
      convert_to_credit_note: "convert_to_credit_note"
    }.each do |method, transition|
      client = stub_client do |stubs|
        stubs.put("/v2/invoices/1/transitions/#{transition}") { json({}) }
      end

      assert_equal true, client.invoices.public_send(method, id: 1), "#{method} requested the wrong path"
      @stubs.verify_stubbed_calls
      @stubs = nil
    end
  end
end
