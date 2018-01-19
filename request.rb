class Request

  def initialize(user)
    @user = user
  end

  def result
    @result ||= begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if response.code == "200"
        JSON.parse(response.body)
      else
        raise "Unexpected result"
      end
    end
  end

  def uri
    @uri ||= begin
      URI::HTTPS.build(
        host: "www.instagram.com",
        path: "/#{@user}/",
        query: "__a=1",
      )
    end
  end

end


