module FreeAgent
  class VatReturnsResource < Resource
    def list(**params)
      response = get_request("vat_returns", params: params)
      Collection.from_response(response, type: VatReturn)
    end

    # Returns are identified by the date their period ends, not by an id
    def retrieve(period_ends_on:)
      response = get_request("vat_returns/#{period_ends_on}")
      VatReturn.new(response.body["vat_return"])
    end

    def mark_as_filed(period_ends_on:, **params)
      response = put_request("vat_returns/#{period_ends_on}/mark_as_filed", body: params)
      response.success?
    end

    def mark_as_unfiled(period_ends_on:)
      response = put_request("vat_returns/#{period_ends_on}/mark_as_unfiled", body: {})
      response.success?
    end

    # Paid and unpaid are marked on an individual payment within the return
    def mark_payment_as_paid(period_ends_on:, payment_id:, **params)
      response = put_request("vat_returns/#{period_ends_on}/payments/#{payment_id}/mark_as_paid", body: params)
      response.success?
    end

    def mark_payment_as_unpaid(period_ends_on:, payment_id:)
      response = put_request("vat_returns/#{period_ends_on}/payments/#{payment_id}/mark_as_unpaid", body: {})
      response.success?
    end
  end
end
