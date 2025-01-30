module FreeAgent
  class BillsResource < Resource
    def list(**params)
      response = get_request("bills", params: params)
      Collection.from_response(response, type: Bill,)
    end

    def list_for_contact(contact:, **params)
      response = get_request("bills?contact=#{contact}", params: params)
      Collection.from_response(response, type: Bill)
    end

    def list_for_project(project:, **params)
      response = get_request("bills?project=#{project}", params: params)
      Collection.from_response(response, type: Bill)
    end

    def retrieve(id:)
      response = get_request("bills/#{id}")
      Bill.new(response.body["bill"])
    end

    def create(contact:, dated_on:, due_on:, reference:, bill_items:, **params)
      attributes = { contact: contact, dated_on: dated_on, due_on: due_on, reference: reference, bill_items: bill_items }

      response = post_request("bills", body: { bill: attributes.merge(params) })
      Bill.new(response.body["bill"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("bills/#{id}", body: { bill: params })
      Bill.new(response.body["bill"]) if response.success?
    end

    def delete(id:)
      response = delete_request("bills/#{id}")
      response.success?
    end
  end
end
