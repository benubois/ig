class Shortcodes
  def self.find(user)
    new(user).result
  end

  def initialize(user)
    @user = user
  end

  def result
    Cache.fetch(uri.to_s, ttl: 3600) {
      Request.get(uri)
    }.scan(/"shortcode":"(.*?)"/).flatten.first(2)
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