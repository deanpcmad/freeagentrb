require "test_helper"

class TransactionsResourceTest < Minitest::Test
  def test_list_uses_the_accounting_path
    client = stub_client do |stubs|
      stubs.get("/v2/accounting/transactions") { json({ "transactions" => [ { "description" => "Sales", "debit_value" => "12.5" } ] }) }
    end

    transaction = client.transactions.list.first

    assert_equal "Sales", transaction.description
    assert_equal 12.5, transaction.debit_value
  end

  def test_list_passes_date_range_params
    client = stub_client do |stubs|
      stubs.get("/v2/accounting/transactions?from_date=2026-01-01&to_date=2026-06-30") { json({ "transactions" => [] }) }
    end

    assert_equal 0, client.transactions.list(from_date: "2026-01-01", to_date: "2026-06-30").count
  end

  def test_retrieve_returns_a_transaction
    client = stub_client do |stubs|
      stubs.get("/v2/accounting/transactions/1") { json({ "transaction" => { "description" => "Sales" } }) }
    end

    assert_equal "Sales", client.transactions.retrieve(id: 1).description
  end
end
