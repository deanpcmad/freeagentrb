module FreeAgent
  class AccountLocksResource < Resource
    def retrieve
      response = get_request("account_locks")
      AccountLock.new(response.body["account_locks"])
    end

    def update(locked_until:, **params)
      response = put_request("account_locks", body: { account_locks: { locked_until: locked_until }.merge(params) })
      AccountLock.new(response.body["account_locks"]) if response.success?
    end

    def delete
      response = delete_request("account_locks")
      response.success?
    end
  end
end
