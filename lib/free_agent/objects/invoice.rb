module FreeAgent
  class Invoice < Object
    def initialize(attributes)
      super to_ostruct(attributes)

      # Convert amounts to BigDecimal
      self.net_value = BigDecimal(self.net_value.to_s).to_f if self.net_value
      self.total_value = BigDecimal(self.total_value.to_s).to_f if self.total_value
      self.paid_value = BigDecimal(self.paid_value.to_s).to_f if self.paid_value
      self.due_value = BigDecimal(self.due_value.to_s).to_f if self.due_value
    end
  end
end
