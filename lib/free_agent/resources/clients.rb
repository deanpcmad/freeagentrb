module FreeAgent
  class ClientsResource < Resource
    def list(**params)
      response = get_request("clients", params: params)
      Collection.from_response(response, type: PracticeClient)
    end
  end
end
