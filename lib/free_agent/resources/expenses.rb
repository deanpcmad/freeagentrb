module FreeAgent
  class ExpensesResource < Resource
    def list(**params)
      response = get_request("expenses", params: params)
      Collection.from_response(response, type: Expense)
    end

    def list_for_user(user:, **params)
      response = get_request("expenses?user=#{user}", params: params)
      Collection.from_response(response, type: Expense)
    end

    def list_for_project(project:, **params)
      response = get_request("expenses?project=#{project}", params: params)
      Collection.from_response(response, type: Expense)
    end

    def retrieve(id:)
      response = get_request("expenses/#{id}")
      Expense.new(response.body["expense"])
    end

    def create(user:, category:, dated_on:, **params)
      attributes = { user: user, category: category, dated_on: dated_on }

      response = post_request("expenses", body: { expense: attributes.merge(params) })
      Expense.new(response.body["expense"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("expenses/#{id}", body: { expense: params })
      Expense.new(response.body["expense"]) if response.success?
    end

    def delete(id:)
      response = delete_request("expenses/#{id}")
      response.success?
    end

    def mileage_settings
      response = get_request("expenses/mileage_settings")
      Object.new(response.body["mileage_settings"])
    end
  end
end
