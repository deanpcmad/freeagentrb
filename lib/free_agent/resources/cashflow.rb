module FreeAgent
  class CashflowResource < Resource
    def retrieve(**params)
      response = get_request("cashflow", params: params)
      Collection.from_response(response, type: CashflowItem)
    end
  end
end
