module FreeAgent
  class InvoicesResource < Resource
    def list(**params)
      response = get_request("invoices", params: params)
      Collection.from_response(response, type: Invoice)
    end

    def list_for_contact(contact:, **params)
      response = get_request("invoices?contact=#{contact}", params: params)
      Collection.from_response(response, type: Invoice)
    end

    def list_for_project(project:, **params)
      response = get_request("invoices?project=#{project}", params: params)
      Collection.from_response(response, type: Invoice)
    end

    def retrieve(id:)
      response = get_request("invoices/#{id}")
      Invoice.new(response.body["invoice"])
    end

    # Returns a Base64-encoded PDF
    def retrieve_pdf(id:)
      response = get_request("invoices/#{id}/pdf")
      response.body["pdf"]["content"] if response.success?
    end

    def create(contact:, dated_on:, payment_terms_in_days: 0, **params)
      attributes = { contact: contact, dated_on: dated_on, payment_terms_in_days: payment_terms_in_days }

      response = post_request("invoices", body: { invoice: attributes.merge(params) })
      Invoice.new(response.body["invoice"]) if response.success?
    end

    def duplicate(id:)
      response = post_request("invoices/#{id}/duplicate", body: {})
      Invoice.new(response.body["invoice"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("invoices/#{id}", body: { invoice: params })
      Invoice.new(response.body["invoice"]) if response.success?
    end

    def delete(id:)
      response = delete_request("invoices/#{id}")
      response.success?
    end

    def email(id:, to:, **params)
      attributes = { to: to }
      response = post_request("invoices/#{id}/send_email", body: { invoice: { email: attributes.merge(params) } })
      response.success?
    end

    def mark_as_sent(id:)
      response = put_request("invoices/#{id}/transitions/mark_as_sent", body: {})
      response.success?
    end

    def mark_as_scheduled(id:)
      response = put_request("invoices/#{id}/transitions/mark_as_scheduled", body: {})
      response.success?
    end

    def mark_as_draft(id:)
      response = put_request("invoices/#{id}/transitions/mark_as_draft", body: {})
      response.success?
    end

    def mark_as_cancelled(id:)
      response = put_request("invoices/#{id}/transitions/mark_as_cancelled", body: {})
      response.success?
    end

    def convert_to_credit_note(id:)
      response = put_request("invoices/#{id}/transitions/convert_to_credit_note", body: {})
      response.success?
    end

    def direct_debit(id:)
      response = post_request("invoices/#{id}/direct_debit", body: {})
      response.success?
    end
  end
end
