require "test_helper"

class BankTransactionExplanationsResourceTest < Minitest::Test
  def test_bank_transaction_explanations_list
    setup_client
    bank_transaction_explanations = @client.bank_transaction_explanations.list(bank_account: 40462)

    assert_equal FreeAgent::Collection, bank_transaction_explanations.class
    assert_equal FreeAgent::BankTransactionExplanation, bank_transaction_explanations.first.class
  end

  def test_bank_transaction_explanations_retrieve
    setup_client
    bank_transaction_explanation = @client.bank_transaction_explanations.retrieve(id: 1775286)
    assert_equal FreeAgent::BankTransactionExplanation, bank_transaction_explanation.class
    assert_equal "Sales", bank_transaction_explanation.type
  end

  def test_bank_transaction_explanations_create
    setup_client
    bank_transaction_explanation = @client.bank_transaction_explanations.create(
      bank_account: 40462,
      bank_transaction: 2615522,
      type: "Payment",
      category: 268,
      dated_on: "2025-10-02",
      gross_value: 6.07,
      description: "AWS Hosting",
    )

    assert_equal FreeAgent::BankTransactionExplanation, bank_transaction_explanation.class
    assert_equal "AWS Hosting", bank_transaction_explanation.description
  end

  def test_bank_transaction_explanations_delete
    setup_client
    result = @client.bank_transaction_explanations.delete(id: 1775294)

    assert_equal true, result
  end
end
