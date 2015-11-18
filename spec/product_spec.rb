require 'spec_helper'

describe Extra::Product do
  describe ".create!" do
    it "persists a valid product" do
      product = VCR.use_cassette('product_success') do
        Extra::Product.create!(skuIdOrigin: 'extra-ruby-1', sellingTitle: 'Extra Ruby', description: 'Extra API in Ruby', brand: 'Digital Pages', EAN: '12345678', defaultPrice: 10, salePrice: 9, categoryList: ["Teste>API"], Weight: 1, Length: 2, Width: 21, Height: 14, availableQuantity: 1, images: ["http://imagemqualquer.com.br/imag.jpg"])
      end
      product.should be_persisted
    end

    it "supports a list of products" do
      product = VCR.use_cassette('product_success') do
        Extra::Product.create!([skuIdOrigin: 'extra-ruby-1', sellingTitle: 'Extra Ruby', description: 'Extra API in Ruby', brand: 'Digital Pages', EAN: '12345678', defaultPrice: 10, salePrice: 9, categoryList: ["Teste>API"], Weight: 1, Length: 2, Width: 21, Height: 14, availableQuantity: 1, images: ["http://imagemqualquer.com.br/imag.jpg"]])
      end
      product.should be_persisted
    end

    it 'should yield the status' do
      yielded = false
      product = VCR.use_cassette('product_success') do
        Extra::Product.create!(skuIdOrigin: 'extra-ruby-1', sellingTitle: 'Extra Ruby', description: 'Extra API in Ruby', brand: 'Digital Pages', EAN: '12345678', defaultPrice: 10, salePrice: 9, categoryList: ["Teste>API"], Weight: 1, Length: 2, Width: 21, Height: 14, availableQuantity: 1, images: ["http://imagemqualquer.com.br/imag.jpg"]) do |response, request, status|
          yielded = status['Location'] == "/loads/products/151868"
        end
      end
      expect(yielded).to be true
    end

    it "should not persist an invalid product" do
      product = VCR.use_cassette('product_not_success') do
        Extra::Product.create!(sellingTitle: 'Extra Ruby', description: 'Extra API in Ruby', brand: 'Digital Pages', EAN: '12345678', defaultPrice: 10, salePrice: 9, categoryList: ["Teste>API"], Weight: 1, Length: 2, Width: 21, Height: 14, availableQuantity: 1, images: ["http://imagemqualquer.com.br/imag.jpg"])
      end
      product.should_not be_persisted
    end
  end
end
