module FreeAgent
  class TasksResource < Resource
    def list(**params)
      response = get_request("tasks", params: params)
      Collection.from_response(response, type: Task)
    end

    def list_for_project(project:, **params)
      response = get_request("tasks?project=#{project}", params: params)
      Collection.from_response(response, type: Task)
    end

    def retrieve(id:)
      response = get_request("tasks/#{id}")
      Task.new(response.body["task"])
    end

    def create(project:, name:, **params)
      attributes = { name: name }

      # The project is passed in the query string rather than the payload
      response = post_request("tasks?project=#{project}", body: { task: attributes.merge(params) })
      Task.new(response.body["task"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("tasks/#{id}", body: { task: params })
      Task.new(response.body["task"]) if response.success?
    end

    def delete(id:)
      response = delete_request("tasks/#{id}")
      response.success?
    end
  end
end
