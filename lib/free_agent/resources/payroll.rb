module FreeAgent
  class PayrollResource < Resource
    # Payroll is organised by tax year, then by period within that year
    def list(year:, **params)
      response = get_request("payroll/#{year}", params: params)
      Collection.from_response(response, type: PayrollPeriod)
    end

    def retrieve(year:, period:)
      response = get_request("payroll/#{year}/#{period}")
      PayrollPeriod.new(response.body["period"])
    end

    def mark_payment_as_paid(year:, period:, **params)
      response = put_request("payroll/#{year}/#{period}/mark_as_paid", body: params)
      response.success?
    end

    def mark_payment_as_unpaid(year:, period:)
      response = put_request("payroll/#{year}/#{period}/mark_as_unpaid", body: {})
      response.success?
    end
  end
end
