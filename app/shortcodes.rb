class Shortcodes

  def self.find(user)
    new(user).result
  end

  def initialize(user)
    @user = user
  end

  def result
    response = Request.get(uri, use_cache: false)
    response.scan(/"shortcode":"(.*?)"/).flatten
  end

  def uri
    @uri ||= begin
      URI::HTTPS.build(
        host: "www.instagram.com",
        path: "/#{@user}/"
      )
    end
  end

end


