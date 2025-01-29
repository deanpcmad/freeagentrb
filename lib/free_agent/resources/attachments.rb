module FreeAgent
  class AttachmentsResource < Resource
    def retrieve(id:)
      response = get_request("attachments/#{id}")
      Attachment.new(response.body["attachment"])
    end

    def delete(id:)
      response = delete_request("attachments/#{id}")
      response.success?
    end
  end
end
