class Request

  def self.get(url)
    new(url).send(:request)
  end

  private

  def initialize(url)
    @url = url
  end

  def request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    http.request(Net::HTTP::Get.new uri.request_uri).body.force_encoding("UTF-8")
  end

  def uri
    @uri ||= begin
      if ENV["PROXY_URL"]
        URI("#{ENV["PROXY_URL"]}?url=#{@url}")
      else
        @url
      end
    end
  end
end
