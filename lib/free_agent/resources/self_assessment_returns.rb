module FreeAgent
  class SelfAssessmentReturnsResource < Resource
    # Nested under a user, and identified by the date the period ends. The
    # Income Tax Returns docs page describes these same endpoints.
    def list(user_id:, **params)
      response = get_request("users/#{user_id}/self_assessment_returns", params: params)
      Collection.from_response(response, type: SelfAssessmentReturn)
    end

    def retrieve(user_id:, period_ends_on:)
      response = get_request("users/#{user_id}/self_assessment_returns/#{period_ends_on}")
      SelfAssessmentReturn.new(response.body["self_assessment_return"])
    end

    def mark_as_filed(user_id:, period_ends_on:, **params)
      response = put_request("users/#{user_id}/self_assessment_returns/#{period_ends_on}/mark_as_filed", body: params)
      response.success?
    end

    def mark_as_unfiled(user_id:, period_ends_on:)
      response = put_request("users/#{user_id}/self_assessment_returns/#{period_ends_on}/mark_as_unfiled", body: {})
      response.success?
    end

    def mark_as_paid(user_id:, period_ends_on:, **params)
      response = put_request("users/#{user_id}/self_assessment_returns/#{period_ends_on}/mark_as_paid", body: params)
      response.success?
    end

    def mark_as_unpaid(user_id:, period_ends_on:)
      response = put_request("users/#{user_id}/self_assessment_returns/#{period_ends_on}/mark_as_unpaid", body: {})
      response.success?
    end
  end
end
