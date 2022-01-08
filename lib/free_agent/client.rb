module FreeAgent
  class Client
    BASE_URL = "https://api.freeagent.com/v2"
    SANDBOX_BASE_URL = "https://api.sandbox.freeagent.com/v2"

    attr_reader :access_token, :sandbox, :adapter

    def initialize(access_token:, sandbox: false, adapter: Faraday.default_adapter, stubs: nil)
      @access_token = access_token
      @sandbox = sandbox
      @adapter = adapter

      # Test stubs for requests
      @stubs = stubs
    end

    def bank_accounts
      BankAccountsResource.new(self)
    end

    def connection
      url = (sandbox == true ? SANDBOX_BASE_URL : BASE_URL)
      @connection ||= Faraday.new(url) do |conn|
        conn.request :authorization, :Bearer, access_token
        conn.request :json

        conn.response :dates
        conn.response :json, content_type: "application/json"

        conn.adapter adapter, @stubs
      end
    end

  end
end
