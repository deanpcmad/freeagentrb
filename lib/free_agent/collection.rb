module FreeAgent
  class Collection
    attr_reader :data, :total, :pagination

    def self.from_response(response, type:)
      body = response.body

      data = body.values.first.map { |attrs| type.new(attrs) }

      total = response.headers["X-total-count"]

      pagination = response.headers["Link"]&.split(", ")&.map do |link|
        url, rel = link.match(/<(.+)>; rel='(.+)'/)&.captures
        [ rel, url ]
      end&.to_h

      new(
        data: data,
        total: total,
        pagination: pagination
      )
    end

    def initialize(data:, total:, pagination: nil)
      @data = data
      @total = total
      @pagination = pagination
    end

    def count
      data.count
    end

    def each(&block)
      data.each(&block)
    end

    def first
      data.first
    end

    def last
      data.last
    end
  end
end
