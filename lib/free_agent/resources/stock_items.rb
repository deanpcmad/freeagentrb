module FreeAgent
  class StockItemsResource < Resource
    def list(**params)
      response = get_request("stock_items", params: params)
      Collection.from_response(response, type: StockItem)
    end

    def retrieve(id:)
      response = get_request("stock_items/#{id}")
      StockItem.new(response.body["stock_item"])
    end
  end
end
