class Request
  attr_reader :uri

  def self.get(uri)
    http_request = Net::HTTP::Get.new uri.request_uri
    new(uri, http_request).send(:request)
  end

  private

  def initialize(uri, http_request)
    @uri = uri
    @http_request = http_request
  end

  def request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    http.request(@http_request).body.force_encoding("UTF-8")
  end
end
