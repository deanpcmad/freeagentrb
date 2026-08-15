module FreeAgent
  class PracticeResource < Resource
    def retrieve
      response = get_request("practice")

      # Unlike other resources, this response isn't wrapped in a root key
      Practice.new(response.body)
    end
  end
end
