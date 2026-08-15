module FreeAgent
  class PriceListItemsResource < Resource
    def list(**params)
      response = get_request("price_list_items", params: params)
      Collection.from_response(response, type: PriceListItem)
    end

    def retrieve(id:)
      response = get_request("price_list_items/#{id}")
      PriceListItem.new(response.body["price_list_item"])
    end

    def create(code:, quantity:, item_type:, description:, price:, **params)
      attributes = { code: code, quantity: quantity, item_type: item_type, description: description, price: price }

      response = post_request("price_list_items", body: { price_list_item: attributes.merge(params) })
      PriceListItem.new(response.body["price_list_item"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("price_list_items/#{id}", body: { price_list_item: params })
      PriceListItem.new(response.body["price_list_item"]) if response.success?
    end

    def delete(id:)
      response = delete_request("price_list_items/#{id}")
      response.success?
    end
  end
end
