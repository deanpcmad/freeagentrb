module FreeAgent
  class NotesResource < Resource
    # The parent is sent in the query string rather than the body, so create
    # takes either contact: or project:
    def list_for_contact(contact:, **params)
      response = get_request("notes", params: params.merge(contact: contact))
      Collection.from_response(response, type: Note)
    end

    def list_for_project(project:, **params)
      response = get_request("notes", params: params.merge(project: project))
      Collection.from_response(response, type: Note)
    end

    def retrieve(id:)
      response = get_request("notes/#{id}")
      Note.new(response.body["note"])
    end

    def create(note:, contact: nil, project: nil, **params)
      query = { contact: contact, project: project }.compact

      response = post_request("notes?#{URI.encode_www_form(query)}", body: { note: { note: note }.merge(params) })
      Note.new(response.body["note"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("notes/#{id}", body: { note: params })
      Note.new(response.body["note"]) if response.success?
    end

    def delete(id:)
      response = delete_request("notes/#{id}")
      response.success?
    end
  end
end
