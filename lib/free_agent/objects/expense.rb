module FreeAgent
  class Expense < Object
    decimal_attributes :gross_value, :native_gross_value, :sales_tax_value
  end
end
