require "test_helper"

class ExpensesResourceTest < Minitest::Test
  def test_expenses_list
    setup_client
    expenses = @client.expenses.list

    assert_equal FreeAgent::Collection, expenses.class
    assert_equal FreeAgent::Expense, expenses.first.class
    assert_equal 2, expenses.count
    assert_equal "Train fare", expenses.first.description
  end

  def test_expenses_retrieve
    setup_client
    expense = @client.expenses.retrieve(id: 1)

    assert_equal FreeAgent::Expense, expense.class
    assert_equal "Train fare", expense.description
    assert_equal "UK/Non-EC", expense.ec_status
  end

  def test_expenses_create
    setup_client
    expense = @client.expenses.create(
      user: "https://api.sandbox.freeagent.com/v2/users/1",
      category: "https://api.sandbox.freeagent.com/v2/categories/285",
      dated_on: "2025-10-03",
      gross_value: "-12.0",
      description: "Train fare"
    )

    assert_equal FreeAgent::Expense, expense.class
    assert_equal "Train fare", expense.description
  end

  def test_expenses_update
    setup_client
    expense = @client.expenses.update(id: 1, description: "Updated train fare")

    assert_equal FreeAgent::Expense, expense.class
    assert_equal "Updated train fare", expense.description
  end

  def test_expenses_delete
    setup_client
    result = @client.expenses.delete(id: 1)

    assert_equal true, result
  end

  def test_expenses_mileage_settings
    setup_client
    settings = @client.expenses.mileage_settings

    assert_equal "0.45", settings.mileage_rate
    assert_equal [ "Car", "Motorcycle", "Bicycle" ], settings.vehicle_types
  end
end
