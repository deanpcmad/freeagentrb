module FreeAgent
  class StockItem < Object
    decimal_attributes :opening_quantity, :opening_balance, :cost_of_sale_value
  end
end
