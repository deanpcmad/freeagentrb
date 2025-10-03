require "test_helper"

class CompanyResourceTest < Minitest::Test
  def test_company_retrieve
    setup_client
    company = @client.company.retrieve

    assert_equal FreeAgent::Company, company.class
    assert_equal "UkSoleTrader", company.type
    assert_equal "FreeAgent RB", company.name
  end
end
