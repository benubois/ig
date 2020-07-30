class Shortcodes
  def self.find(user)
    new(user).result
  end

  def initialize(user)
    @user = user
  end

  def result
    Request.get(uri).scan(/"shortcode":"(.*?)"/).flatten.first(3)
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