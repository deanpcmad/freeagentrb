module FreeAgent
  class CashflowItem < Object
    decimal_attributes :opening_balance, :closing_balance, :money_in, :money_out
  end
end
