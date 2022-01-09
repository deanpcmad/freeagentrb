module FreeAgent
  class CompanyResource < Resource

    def retrieve
      response = get_request("company")
      Company.new(response.body["company"])
    end

  end
end
