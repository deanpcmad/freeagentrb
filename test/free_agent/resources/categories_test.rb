require "test_helper"

class CategoriesResourceTest < Minitest::Test
  RESPONSE = {
    "admin_expenses_categories" => [
      { "url" => "https://api.freeagent.com/v2/categories/250", "description" => "Accommodation and Travel", "nominal_code" => "250", "allowable_for_tax" => true }
    ],
    "cost_of_sales_categories" => [
      { "url" => "https://api.freeagent.com/v2/categories/150", "description" => "Cost of Sales", "nominal_code" => "150" }
    ],
    "income_categories" => [
      { "url" => "https://api.freeagent.com/v2/categories/001", "description" => "Sales", "nominal_code" => "001" }
    ],
    "general_categories" => [
      { "url" => "https://api.freeagent.com/v2/categories/750", "description" => "Bank Loans", "nominal_code" => "750" }
    ]
  }.freeze

  def test_list_flattens_every_category_type
    client = stub_client do |stubs|
      stubs.get("/v2/categories") { json(RESPONSE) }
    end

    categories = client.categories.list

    # Unlike other resources this returns a plain Array, not a Collection
    assert_equal Array, categories.class
    assert_equal 4, categories.size
    assert_equal FreeAgent::Category, categories.first.class
  end

  def test_list_tags_each_category_with_its_type
    client = stub_client do |stubs|
      stubs.get("/v2/categories") { json(RESPONSE) }
    end

    categories = client.categories.list
    types = categories.map(&:category_type)

    assert_equal %w[admin_expenses_categories cost_of_sales_categories income_categories general_categories], types
  end

  def test_list_preserves_category_attributes
    client = stub_client do |stubs|
      stubs.get("/v2/categories") { json(RESPONSE) }
    end

    admin = client.categories.list.first

    assert_equal "Accommodation and Travel", admin.description
    assert_equal "250", admin.nominal_code
    assert_equal true, admin.allowable_for_tax
  end
end
