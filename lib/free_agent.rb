require "faraday"
require "faraday_middleware"
require "faraday/multipart"
require "json"

require_relative "free_agent/version"

module FreeAgent

  autoload :Client, "free_agent/client"
  autoload :Collection, "free_agent/collection"
  autoload :Error, "free_agent/error"
  autoload :Resource, "free_agent/resource"
  autoload :Object, "free_agent/object"

  autoload :CompanyResource, "free_agent/resources/company"
  autoload :ContactsResource, "free_agent/resources/contacts"
  autoload :BankAccountsResource, "free_agent/resources/bank_accounts"
  autoload :BankTransactionsResource, "free_agent/resources/bank_transactions"
  autoload :BankTransactionExplanationsResource, "free_agent/resources/bank_transaction_explanations"
  autoload :ProjectsResource, "free_agent/resources/projects"
  autoload :TasksResource, "free_agent/resources/tasks"
  autoload :TimeslipsResource, "free_agent/resources/timeslips"
  autoload :UsersResource, "free_agent/resources/users"
  autoload :AttachmentsResource, "free_agent/resources/attachments"

  autoload :Company, "free_agent/objects/company"
  autoload :Contact, "free_agent/objects/contact"
  autoload :BankAccount, "free_agent/objects/bank_account"
  autoload :BankTransaction, "free_agent/objects/bank_transaction"
  autoload :BankTransactionExplanation, "free_agent/objects/bank_transaction_explanation"
  autoload :Project, "free_agent/objects/project"
  autoload :Task, "free_agent/objects/task"
  autoload :Timeslip, "free_agent/objects/timeslip"
  autoload :User, "free_agent/objects/user"
  autoload :Attachment, "free_agent/objects/attachment"

end
