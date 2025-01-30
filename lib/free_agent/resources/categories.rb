module FreeAgent
  class CategoriesResource < Resource
    def list(**params)
      response = get_request("categories", params: params)

      responses = []

      response.body.keys.each do |key|
        response.body[key].each do |value|
          value["category_type"] = key
          responses << Category.new(value)
        end
      end

      responses
    end
  end
end
