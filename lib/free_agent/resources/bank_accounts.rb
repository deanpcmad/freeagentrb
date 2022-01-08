module FreeAgent
  class BankAccountsResource < Resource

    def list
      response = get_request("bank_accounts")
      Collection.from_response(response, type: BankAccount)
    end

  end
end
