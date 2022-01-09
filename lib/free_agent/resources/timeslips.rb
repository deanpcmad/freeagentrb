module FreeAgent
  class TimeslipsResource < Resource

    def list(**params)
      response = get_request("timeslips", params: params)
      Collection.from_response(response, type: Timeslip, key: "timeslips")
    end

    def list_for_user(user:, **params)
      response = get_request("timeslips?user=#{user}", params: params)
      Collection.from_response(response, type: Timeslip, key: "timeslips")
    end

    def list_for_task(task:, **params)
      response = get_request("timeslips?task=#{task}", params: params)
      Collection.from_response(response, type: Timeslip, key: "timeslips")
    end

    def list_for_project(project:, **params)
      response = get_request("timeslips?project=#{project}", params: params)
      Collection.from_response(response, type: Timeslip, key: "timeslips")
    end

    def retrieve(id:)
      response = get_request("timeslips/#{id}")
      Timeslip.new(response.body["timeslip"])
    end

    def create(task:, user:, project:, dated_on:, hours:,  **params)
      attributes = {task: task, user: user, project: project, dated_on: dated_on, hours: hours}

      response = post_request("timeslips", body: attributes.merge(params))
      Timeslip.new(response.body["timeslip"]) if response.success?
    end

    def update(id:, **params)
      response = put_request("timeslips/#{id}", body: params)
      Timeslip.new(response.body["timeslip"]) if response.success?
    end

    def delete(id:)
      response = delete_request("timeslips/#{id}")
      response.success?
    end

  end
end
