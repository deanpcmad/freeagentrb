module FreeAgent
  class ProfitAndLossResource < Resource
    def summary(**params)
      response = get_request("accounting/profit_and_loss/summary", params: params)
      Collection.from_response(response, type: ProfitAndLossItem)
    end
  end
end
