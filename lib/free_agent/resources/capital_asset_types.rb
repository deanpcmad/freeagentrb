module FreeAgent
  class CapitalAssetTypesResource < Resource
    def list(**params)
      response = get_request("capital_asset_types", params: params)
      Collection.from_response(response, type: CapitalAssetType)
    end

    def retrieve(id:)
      response = get_request("capital_asset_types/#{id}")
      CapitalAssetType.new(response.body["capital_asset_type"])
    end

    def create(name:, **params)
      response = post_request("capital_asset_types", body: { capital_asset_type: { name: name }.merge(params) })
      CapitalAssetType.new(response.body["capital_asset_type"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("capital_asset_types/#{id}", body: { capital_asset_type: params })
      CapitalAssetType.new(response.body["capital_asset_type"]) if response.success?
    end

    def delete(id:)
      response = delete_request("capital_asset_types/#{id}")
      response.success?
    end
  end
end
