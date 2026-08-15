module FreeAgent
  class EmailAddressesResource < Resource
    # Returns an Array of verified sender email addresses as strings
    def list(**params)
      response = get_request("email_addresses", params: params)
      response.body["email_addresses"]
    end
  end
end
