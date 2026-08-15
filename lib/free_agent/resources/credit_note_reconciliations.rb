module FreeAgent
  class CreditNoteReconciliationsResource < Resource
    def list(**params)
      response = get_request("credit_note_reconciliations", params: params)
      Collection.from_response(response, type: CreditNoteReconciliation)
    end

    def retrieve(id:)
      response = get_request("credit_note_reconciliations/#{id}")
      CreditNoteReconciliation.new(response.body["credit_note_reconciliation"])
    end

    def create(credit_note:, invoice:, value:, **params)
      attributes = { credit_note: credit_note, invoice: invoice, value: value }

      response = post_request("credit_note_reconciliations", body: { credit_note_reconciliation: attributes.merge(params) })
      CreditNoteReconciliation.new(response.body["credit_note_reconciliation"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("credit_note_reconciliations/#{id}", body: { credit_note_reconciliation: params })
      CreditNoteReconciliation.new(response.body["credit_note_reconciliation"]) if response.success?
    end

    def delete(id:)
      response = delete_request("credit_note_reconciliations/#{id}")
      response.success?
    end
  end
end
