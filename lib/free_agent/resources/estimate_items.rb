module FreeAgent
  class EstimateItemsResource < Resource
    def create(estimate:, **params)
      # The payload has two root elements: the estimate's URL, and the item
      response = post_request("estimate_items", body: { estimate: estimate, estimate_item: params })
      EstimateItem.new(response.body["estimate_item"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("estimate_items/#{id}", body: { estimate_item: params })
      EstimateItem.new(response.body["estimate_item"]) if response.success?
    end

    def delete(id:)
      response = delete_request("estimate_items/#{id}")
      response.success?
    end
  end
end
