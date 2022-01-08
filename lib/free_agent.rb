require "faraday"
require "faraday_middleware"
require "json"

require_relative "free_agent/version"

module FreeAgent

  autoload :Client, "free_agent/client"
  autoload :Collection, "free_agent/collection"
  autoload :Error, "free_agent/error"
  autoload :Resource, "free_agent/resource"
  autoload :Object, "free_agent/object"

  autoload :BankAccountsResource, "free_agent/resources/bank_accounts"

  autoload :BankAccount, "free_agent/objects/bank_account"

end
