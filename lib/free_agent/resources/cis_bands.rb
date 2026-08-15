module FreeAgent
  class CisBandsResource < Resource
    def list(**params)
      response = get_request("cis_bands", params: params)
      Collection.from_response(response, type: CisBand)
    end
  end
end
