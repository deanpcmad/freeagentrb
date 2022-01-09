module FreeAgent
  class BankAccountsResource < Resource

    def list(view: nil)
      url = view.nil? ? "bank_accounts" : "bank_accounts?view=#{view}"

      response = get_request(url)
      Collection.from_response(response, type: BankAccount, key: "bank_accounts")
    end

    def retrieve(id:)
      response = get_request("bank_accounts/#{id}")
      BankAccount.new(response.body["bank_account"])
    end

    def create(type:, name:, opening_balance:, **params)
      attributes = {type: type, name: name, opening_balance: opening_balance}
      response = post_request("bank_accounts", body: attributes.merge(params))
      BankAccount.new(response.body["bank_account"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("bank_accounts/#{id}", body: params)
      BankAccount.new(response.body["bank_account"]) if response.success?
    end

    def delete(id:)
      response = delete_request("bank_accounts/#{id}")
      response.success?
    end

  end
end
