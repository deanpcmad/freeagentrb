module FreeAgent
  class ProjectsResource < Resource
    def list(**params)
      response = get_request("projects", params: params)
      Collection.from_response(response, type: Project)
    end

    def list_for_contact(contact:, **params)
      response = get_request("projects?contact=#{contact}", params: params)
      Collection.from_response(response, type: Project)
    end

    def retrieve(id:)
      response = get_request("projects/#{id}")
      Project.new(response.body["project"])
    end

    def create(contact:, name:, status:, currency:, budget_units:, **params)
      attributes = { contact: contact, name: name, status: status, currency: currency, budget_units: budget_units }

      response = post_request("projects", body: attributes.merge(params))
      Project.new(response.body["project"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("projects/#{id}", body: params)
      Project.new(response.body["project"]) if response.success?
    end

    def delete(id:)
      response = delete_request("projects/#{id}")
      response.success?
    end
  end
end
