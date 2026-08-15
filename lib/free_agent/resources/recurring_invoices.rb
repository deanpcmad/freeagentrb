module FreeAgent
  class RecurringInvoicesResource < Resource
    def list(**params)
      response = get_request("recurring_invoices", params: params)
      Collection.from_response(response, type: RecurringInvoice)
    end

    def list_for_contact(contact:, **params)
      response = get_request("recurring_invoices?contact=#{contact}", params: params)
      Collection.from_response(response, type: RecurringInvoice)
    end

    def list_for_project(project:, **params)
      response = get_request("recurring_invoices?project=#{project}", params: params)
      Collection.from_response(response, type: RecurringInvoice)
    end

    def retrieve(id:)
      response = get_request("recurring_invoices/#{id}")
      RecurringInvoice.new(response.body["recurring_invoice"])
    end
  end
end
