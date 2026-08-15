require "test_helper"

class BillsResourceTest < Minitest::Test
  BILL = {
    "url" => "https://api.freeagent.com/v2/bills/1",
    "contact" => "https://api.freeagent.com/v2/contacts/2",
    "reference" => "Bill-001",
    "dated_on" => "2011-08-29",
    "due_on" => "2011-09-28",
    "currency" => "GBP",
    "total_value" => "100.0",
    "paid_value" => "0.0",
    "due_value" => "100.0",
    "status" => "Open",
    "bill_items" => [
      { "description" => "Stationery", "category" => "https://api.freeagent.com/v2/categories/285", "total_value" => "100.0" }
    ]
  }.freeze

  def test_list
    client = stub_client do |stubs|
      stubs.get("/v2/bills") { json({ "bills" => [ BILL ] }) }
    end

    bills = client.bills.list

    assert_equal FreeAgent::Collection, bills.class
    assert_equal FreeAgent::Bill, bills.first.class
    assert_equal "Bill-001", bills.first.reference
  end

  def test_list_for_contact
    client = stub_client do |stubs|
      stubs.get("/v2/bills?contact=https://api.freeagent.com/v2/contacts/2") { json({ "bills" => [ BILL ] }) }
    end

    assert_equal 1, client.bills.list_for_contact(contact: "https://api.freeagent.com/v2/contacts/2").count
  end

  def test_retrieve
    client = stub_client do |stubs|
      stubs.get("/v2/bills/1") { json({ "bill" => BILL }) }
    end

    bill = client.bills.retrieve(id: 1)

    assert_equal "100.0", bill.total_value
    assert_equal "Stationery", bill.bill_items.first.description
  end

  def test_create_wraps_payload_in_bill_root
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/bills") do |env|
        body = JSON.parse(env.body)
        json({ "bill" => BILL }, status: 201)
      end
    end

    items = [ { "description" => "Stationery", "category" => "https://api.freeagent.com/v2/categories/285", "total_value" => "100.0" } ]

    client.bills.create(
      contact: "https://api.freeagent.com/v2/contacts/2",
      dated_on: "2011-08-29",
      due_on: "2011-09-28",
      reference: "Bill-001",
      bill_items: items
    )

    assert_equal "Bill-001", body["bill"]["reference"]
    assert_equal "Stationery", body["bill"]["bill_items"].first["description"]
  end

  def test_update_wraps_payload_in_bill_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/bills/1") do |env|
        body = JSON.parse(env.body)
        json({ "bill" => BILL })
      end
    end

    client.bills.update(id: 1, reference: "Bill-002")

    assert_equal({ "bill" => { "reference" => "Bill-002" } }, body)
  end

  def test_delete
    client = stub_client do |stubs|
      stubs.delete("/v2/bills/1") { json({}) }
    end

    assert_equal true, client.bills.delete(id: 1)
  end
end
