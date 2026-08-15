module FreeAgent
  class Transaction < Object
    decimal_attributes :debit_value, :credit_value, :running_total
  end
end
