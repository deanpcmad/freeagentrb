module FreeAgent
  class HirePurchasesResource < Resource
    def list(**params)
      response = get_request("hire_purchases", params: params)
      Collection.from_response(response, type: HirePurchase)
    end

    def retrieve(id:)
      response = get_request("hire_purchases/#{id}")
      HirePurchase.new(response.body["hire_purchase"])
    end
  end
end
