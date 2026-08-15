module FreeAgent
  class BalanceSheetItem < Object
    decimal_attributes :opening_balance, :closing_balance, :movement
  end
end
