module FreeAgent
  class CapitalAssetsResource < Resource
    # Pass include_history: true to include each asset's depreciation history
    def list(**params)
      response = get_request("capital_assets", params: params)
      Collection.from_response(response, type: CapitalAsset)
    end

    def retrieve(id:, **params)
      response = get_request("capital_assets/#{id}", params: params)
      CapitalAsset.new(response.body["capital_asset"])
    end
  end
end
