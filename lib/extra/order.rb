module Extra
  class Order < Base
    { unapproved: :new, approved: :approved, canceled: :canceled }.each do |method_name, status|
      define_singleton_method method_name do |page: 1|
        get("orders/status/#{status}", _offset: ((page - 1) * 50), _limit: 50)
      end
    end

    def self.find(id)
      parse_get("orders/#{id}")
    end

    def track!(params)
      JSON.parse(self.class.post("orders/#{self['id']}/ordersItems/trackings/", params))
    end

    { cancel: :cancel, delivered: :delivered, return: :return, sent: :sent  }.each do |method_name, status|
      define_singleton_method method_name do |id, params|
        post("orders/#{id}/trackings/#{status}", params)
      end
    end
  end
end
