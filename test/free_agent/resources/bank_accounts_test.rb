require "test_helper"

class BankAccountsResourceTest < Minitest::Test
  def test_bank_accounts_list
    setup_client
    bank_accounts = @client.bank_accounts.list

    assert_equal FreeAgent::Collection, bank_accounts.class
    assert_equal FreeAgent::BankAccount, bank_accounts.first.class
  end

  def test_bank_accounts_retrieve
    setup_client
    bank_account = @client.bank_accounts.retrieve(id: 40459)

    assert_equal FreeAgent::BankAccount, bank_account.class
    assert_equal "Business Current Account", bank_account.name
  end

  def test_bank_accounts_create
    setup_client
    bank_account = @client.bank_accounts.create(
      type: "StandardBankAccount",
      name: "Test Account",
      opening_balance: 1000.0,
      currency: "GBP"
    )

    assert_equal FreeAgent::BankAccount, bank_account.class
    assert_equal "Test Account", bank_account.name
  end

  def test_bank_accounts_update
    setup_client
    bank_account = @client.bank_accounts.update(
      id: 40459,
      name: "Updated Account Name"
    )

    assert_equal FreeAgent::BankAccount, bank_account.class
    assert_equal "Updated Account Name", bank_account.name
  end

  def test_bank_accounts_delete
    setup_client
    result = @client.bank_accounts.delete(id: 40463)

    assert_equal true, result
  end
end
