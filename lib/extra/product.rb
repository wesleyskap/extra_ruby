module Extra
  class Product < Base
    def self.create!(params)
      post('loads/products', [params].flatten, content_type: :json) do |body, request, result|
        @result = result
        @request = request
        @body = body
        yield body, request, result if block_given?
        new persisted: result.is_a?(Net::HTTPCreated)
      end
    end
  end
end
