module FreeAgent
  class BankTransactionExplanationsResource < Resource
    def list(bank_account:, **params)
      attributes = { bank_account: bank_account }

      response = get_request("bank_transaction_explanations", params: attributes.merge(params))
      Collection.from_response(response, type: BankTransactionExplanation, key: "bank_transaction_explanations")
    end

    def retrieve(id:)
      response = get_request("bank_transaction_explanations/#{id}")
      BankTransactionExplanation.new(response.body["bank_transaction_explanation"])
    end

    def create(**params)
      raise "bank_account or bank_transaction is required" unless !params[:bank_account].nil? || !params[:bank_transaction].nil?
      response = post_request("bank_transaction_explanations", body: params)
      BankTransactionExplanation.new(response.body["bank_transaction_explanation"])
    end

    def delete(id:)
      response = delete_request("bank_transaction_explanations/#{id}")
      response.success?
    end
  end
end
