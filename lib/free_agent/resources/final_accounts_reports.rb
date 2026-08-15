module FreeAgent
  class FinalAccountsReportsResource < Resource
    def list(**params)
      response = get_request("final_accounts_reports", params: params)
      Collection.from_response(response, type: FinalAccountsReport)
    end

    # Reports are identified by the date their accounting period ends
    def retrieve(period_ends_on:)
      response = get_request("final_accounts_reports/#{period_ends_on}")
      FinalAccountsReport.new(response.body["final_accounts_report"])
    end

    def mark_as_filed(period_ends_on:, **params)
      response = put_request("final_accounts_reports/#{period_ends_on}/mark_as_filed", body: params)
      response.success?
    end

    def mark_as_unfiled(period_ends_on:)
      response = put_request("final_accounts_reports/#{period_ends_on}/mark_as_unfiled", body: {})
      response.success?
    end
  end
end
