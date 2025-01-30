module FreeAgent
  class BankTransaction < Object
    def initialize(attributes)
      super to_ostruct(attributes)

      # Convert amounts to BigDecimal
      self.amount = BigDecimal(self.amount.to_s).to_f if self.amount
      self.unexplained_amount = BigDecimal(self.unexplained_amount.to_s).to_f if self.unexplained_amount

      # Convert amounts in bank_transaction_explanations to BigDecimal
      if self.bank_transaction_explanations
        self.bank_transaction_explanations.each do |explanation|
          explanation.id = explanation.url.match(/\d{2,}/)[0] if explanation.url
          explanation.gross_value = BigDecimal(explanation.gross_value.to_s).to_f if explanation.gross_value
          explanation.foreign_currency_value = BigDecimal(explanation.foreign_currency_value.to_s).to_f if explanation.foreign_currency_value
          explanation.transfer_value = BigDecimal(explanation.transfer_value.to_s).to_f if explanation.transfer_value
        end
      end
    end
  end
end
