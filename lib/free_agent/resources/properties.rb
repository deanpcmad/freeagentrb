module FreeAgent
  class PropertiesResource < Resource
    # UkUnincorporatedLandlord companies only
    def list(**params)
      response = get_request("properties", params: params)
      Collection.from_response(response, type: Property)
    end

    def retrieve(id:)
      response = get_request("properties/#{id}")
      Property.new(response.body["property"])
    end

    def create(**params)
      response = post_request("properties", body: { property: params })
      Property.new(response.body["property"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("properties/#{id}", body: { property: params })
      Property.new(response.body["property"]) if response.success?
    end

    def delete(id:)
      response = delete_request("properties/#{id}")
      response.success?
    end
  end
end
