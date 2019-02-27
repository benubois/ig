require "uri"
require "net/http"
require "json"

class Post

  def initialize(shortcode)
    @shortcode = shortcode
  end

  def url
    "https://www.instagram.com/p/#{@shortcode}/"
  end

  def published
    date = Time.now
    date.utc.strftime '%Y-%m-%dT%H:%M:%S%z'
  end

  def id
    @shortcode
  end

  def display_src
    "https://instagram.com/p/#{@shortcode}/media/?size=l"
  end

  def caption
    oembed.dig("title").split("\n").reject(&:empty?).join("<br>")
  end

  def video_url
    post_markup.body.scan(/<meta.*property="og:video".*content="(.*)".*\/>/i).flatten.first
  end

  def profile_image_url
    post_markup.scan(/"profile_pic_url":"([^"]+)","username":"#{Regexp.quote(screen_name)}"/).flatten.first
  rescue
    nil
  end

  private

    def request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request)
    end

    def post_markup
      @post_markup ||= begin
        uri = URI::HTTPS.build(
          host: "www.instagram.com",
          path: "/p/#{@shortcode}/"
        )
        request(uri)
      end
    end

    def oembed
      @oembed ||= begin
        uri = URI::HTTPS.build(
          host: "api.instagram.com",
          path: "/oembed/",
          query: "url=#{url}"
        )
        JSON.load(request(uri).body)
      end
    end

end