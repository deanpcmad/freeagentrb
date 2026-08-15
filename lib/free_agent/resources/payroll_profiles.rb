module FreeAgent
  class PayrollProfilesResource < Resource
    # Pass user: to fetch the profiles for a single user
    def list(year:, **params)
      response = get_request("payroll_profiles/#{year}", params: params)
      Collection.from_response(response, type: PayrollProfile)
    end
  end
end
