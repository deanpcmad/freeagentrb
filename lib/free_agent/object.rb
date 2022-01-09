require "ostruct"

module FreeAgent
  class Object < OpenStruct
    def initialize(attributes)
      super to_ostruct(attributes)

      # The FreeAgent API doesn't send an ID so generate it from the URL 
      if attributes["url"]
        self.id = attributes["url"].split("/").last
      end
    end

    def to_ostruct(obj)
      if obj.is_a?(Hash)
        OpenStruct.new(obj.map { |key, val| [key, to_ostruct(val)] }.to_h)
      elsif obj.is_a?(Array)
        obj.map { |o| to_ostruct(o) }
      else # Assumed to be a primitive value
        obj
      end
    end
  end
end
