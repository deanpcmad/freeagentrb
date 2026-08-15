module FreeAgent
  class CorporationTaxReturnsResource < Resource
    def list(**params)
      response = get_request("corporation_tax_returns", params: params)
      Collection.from_response(response, type: CorporationTaxReturn)
    end

    # Returns are identified by the date their period ends, not by an id
    def retrieve(period_ends_on:)
      response = get_request("corporation_tax_returns/#{period_ends_on}")
      CorporationTaxReturn.new(response.body["corporation_tax_return"])
    end

    def mark_as_filed(period_ends_on:, **params)
      response = put_request("corporation_tax_returns/#{period_ends_on}/mark_as_filed", body: params)
      response.success?
    end

    def mark_as_unfiled(period_ends_on:)
      response = put_request("corporation_tax_returns/#{period_ends_on}/mark_as_unfiled", body: {})
      response.success?
    end

    def mark_as_paid(period_ends_on:, **params)
      response = put_request("corporation_tax_returns/#{period_ends_on}/mark_as_paid", body: params)
      response.success?
    end

    def mark_as_unpaid(period_ends_on:)
      response = put_request("corporation_tax_returns/#{period_ends_on}/mark_as_unpaid", body: {})
      response.success?
    end
  end
end
