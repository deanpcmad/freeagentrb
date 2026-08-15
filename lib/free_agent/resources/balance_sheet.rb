module FreeAgent
  class BalanceSheetResource < Resource
    def retrieve(**params)
      response = get_request("accounting/balance_sheet", params: params)
      Collection.from_response(response, type: BalanceSheetItem)
    end

    def opening_balances(**params)
      response = get_request("accounting/balance_sheet/opening_balances", params: params)
      Collection.from_response(response, type: BalanceSheetItem)
    end
  end
end
