module FreeAgent
  class TransactionsResource < Resource
    # The general ledger, as opposed to bank transactions. Date ranges given
    # with from_date and to_date must be 12 months or less.
    def list(**params)
      response = get_request("accounting/transactions", params: params)
      Collection.from_response(response, type: Transaction)
    end

    def retrieve(id:)
      response = get_request("accounting/transactions/#{id}")
      Transaction.new(response.body["transaction"])
    end
  end
end
