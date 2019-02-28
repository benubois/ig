class Request

  attr_reader :uri, :request, :use_cache

  def initialize(uri, use_cache)
    @uri = uri
    @use_cache = use_cache
  end

  def self.get(uri, use_cache: true)
    if use_cache
      new(uri, use_cache).cached_request
    else
      new(uri, use_cache).request
    end
  end

  def cached_request
    cache do
      request
    end
  end

  def request
    request = Net::HTTP::Get.new uri.request_uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.request(request).body.force_encoding("UTF-8")
  end

  def cache(&block)
    path = File.join(Dir.tmpdir, uri_hash)
    File.read path
  rescue Errno::ENOENT
    value = yield
    File.open(path, "w") { |file| file.write value }
    value
  end

  def uri_hash
    Digest::SHA1.hexdigest uri.to_s
  end



end