module Extra
  class Item < Base
    def self.find(sku_id)
      parse_get("sellerItems/#{sku_id.is_a?(Hash) ? "skuOrigin/#{sku_id['origin_sku']}" : sku_id}")
    end

    def self.stock(sku_id, params = {})
      put("sellerItems/#{sku_id}", params)
    end
  end
end
