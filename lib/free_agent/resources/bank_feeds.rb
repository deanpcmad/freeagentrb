module FreeAgent
  class BankFeedsResource < Resource
    def list(**params)
      response = get_request("bank_feeds", params: params)
      Collection.from_response(response, type: BankFeed)
    end

    def retrieve(id:)
      response = get_request("bank_feeds/#{id}")
      BankFeed.new(response.body["bank_feed"])
    end
  end
end
