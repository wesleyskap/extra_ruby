module Extra
  class Product < Base
    def self.create!(params)
      post('loads/products', [params].flatten, content_type: :gzip) do |body, request, result|
        yield body, request, result if block_given?
        new persisted: result.is_a?(Net::HTTPCreated)
      end
    end
  end
end
