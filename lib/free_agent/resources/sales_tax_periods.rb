module FreeAgent
  class SalesTaxPeriodsResource < Resource
    # US and Universal companies only
    def list(**params)
      response = get_request("sales_tax_periods", params: params)
      Collection.from_response(response, type: SalesTaxPeriod)
    end

    def retrieve(id:)
      response = get_request("sales_tax_periods/#{id}")
      SalesTaxPeriod.new(response.body["sales_tax_period"])
    end

    def create(starts_on:, first_rate:, **params)
      attributes = { starts_on: starts_on, first_rate: first_rate }

      response = post_request("sales_tax_periods", body: { sales_tax_period: attributes.merge(params) })
      SalesTaxPeriod.new(response.body["sales_tax_period"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("sales_tax_periods/#{id}", body: { sales_tax_period: params })
      SalesTaxPeriod.new(response.body["sales_tax_period"]) if response.success?
    end

    def delete(id:)
      response = delete_request("sales_tax_periods/#{id}")
      response.success?
    end
  end
end
