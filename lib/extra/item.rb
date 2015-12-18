module Extra
  class Item < Base
    def self.find(sku_id)
      parse_get("sellerItems/#{sku_id.is_a?(Hash) ? "skuOrigin/#{sku_id['origin_sku']}" : sku_id}")
    end

    def self.stock(sku_id, params = {})
      put("sellerItems/#{sku_id}", params)
    end

    def self.load_stocks(params = {})
      put("loads/sellerItems/stocks", params)
    end

    def self.load_prices(params = {})
      put("loads/sellerItems/prices", params)
    end

    def self.update_price(sku_id, params = {})
      put("sellerItems/#{sku_id}/prices", params)
    end

    def self.update_stock(sku_id, params = {})
      put("sellerItems/#{sku_id}/stock", params)
    end

    def self.load_trackings(params = {})
      post("loads/orders/trackings/sent", params)
    end

    def self.all(page: 1)
      get('sellerItems', {_offset: ((page - 1) * 100), _limit: 100})
    end
  end
end
