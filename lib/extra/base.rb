module Extra
  class Base
    def [](key)
      @data[1]
    end

    def initialize(data)
      @data = data
    end

    def persisted?
      self[:persisted]
    end

    def self.get(path, params)
      parse_get("#{path}?#{to_params(params)}").map { |params| new params }
    end

    def self.parse_get(path)
      JSON.parse execute(:get, path)
    end

    def self.post(path, body, headers = {}, &block)
      execute(:post, path, { body: body }, headers, &block)
    end

    def self.put(path, body, headers = {}, &block)
      execute(:put, path, { body: body }, headers, &block)
    end

    def self.execute(method, path, params = {}, content_type: :json, &block)
      params[:payload] = to_payload(params[:body], content_type: content_type) if params[:body]
      headers = { content_type: "application/#{content_type}", 'client_id' => app_token, 'access_token' => auth_token }
      RestClient::Request.execute({ method: method, url: "#{endpoint}/#{path}", headers: headers }.merge(params), &block)
    end

    def self.to_payload(body, content_type:)
      json = JSON.generate(body)
      content_type == :json ? json : to_gzip(json)
    end

    def self.to_gzip(body)
      io = StringIO.new("w")
      gzip = Zlib::GzipWriter.new io
      gzip.write body
      gzip.close
      io.string
    end

    def self.endpoint
      "https://#{subdomain}.cnova.com/api/v2"
    end

    def self.app_token
      Extra.config[:app_token]
    end

    def self.auth_token
      Extra.config[:auth_token]
    end

    def self.subdomain
      Extra.config[:sandbox] ? "sandbox" : "api"
    end

    def self.to_params(params)
      params.map { |key, value| "#{key}=#{value}" }.join "&"
    end

    def self.camelize(key)
      key.to_s.split(/_/).map{ |word| word.capitalize }.join('')
    end
  end
end
