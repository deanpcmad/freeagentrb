require "ostruct"

module FreeAgent
  class Object < OpenStruct
    # Declares attributes the API sends as strings which should be exposed as
    # floats, e.g. decimal_attributes :total_value
    def self.decimal_attributes(*names)
      @decimal_attributes = names.map(&:to_s)
    end

    def self.decimal_attribute_names
      @decimal_attributes || []
    end

    def initialize(attributes)
      super to_ostruct(attributes)

      # The FreeAgent API doesn't send an ID so generate it from the URL
      if attributes["url"]
        number = attributes["url"].match(/\d{2,}/)
        self.id = number[0] unless number.nil?
      end

      self.class.decimal_attribute_names.each do |name|
        value = self[name]
        next if value.nil? || value.to_s.empty?

        self[name] = BigDecimal(value.to_s).to_f
      end
    end

    def to_ostruct(obj)
      if obj.is_a?(Hash)
        OpenStruct.new(obj.map { |key, val| [ key, to_ostruct(val) ] }.to_h)
      elsif obj.is_a?(Array)
        obj.map { |o| to_ostruct(o) }
      else # Assumed to be a primitive value
        obj
      end
    end
  end
end
