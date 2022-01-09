module FreeAgent
  class EstimateItemsResource < Resource

    def create(estimate:, **params)
      attributes = {estimate: estimate}

      response = post_request("estimate_items", body: attributes.merge(params))
      EstimateItem.new(response.body["estimate_item"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("estimate_items/#{id}", body: params)
      EstimateItem.new(response.body["estimate_item"]) if response.success?
    end

    def delete(id:)
      response = delete_request("estimate_items/#{id}")
      response.success?
    end

  end
end
