class Page
  def initialize(shortcode, username)
    @shortcode = shortcode
    @username = username
  end

  def caption
    @caption ||= oembed.dig("title").split("\n").reject(&:empty?).join("<br>")
  end

  def video_url
    @video_url ||= markup.scan(/<meta.*og:video.*content="(.*)".*/i).flatten.first
  end

  def profile_image_url
    @profile_image_url ||= begin
      url = markup.scan(/"profile_pic_url":"([^"]+)","username":"#{Regexp.quote(@username)}"/).flatten.first
      url = JSON.load('{"url": "%s"}' % url)
      url["url"]
    end
  end

  def author_name
    @author_name ||= begin
      name = markup.scan(/<meta.*og:title.*content="(.*)/i).flatten.first.split(" on Instagram")
      if name.length > 1
        CGI.unescapeHTML(name.first)
      else
        @username
      end
    end
  rescue
    @author_name = @username
  end

  def gallery
    []
  end

  def video?
    !video_url.nil?
  end

  def image?
    !video?
  end

  private

  def markup
    @markup ||= begin
      uri = URI::HTTPS.build(
        host: "www.instagram.com",
        path: "/p/#{@shortcode}/"
      )
      Cache.fetch(uri.to_s) { Request.get(uri) }
    end
  end

  def oembed
    @oembed ||= begin
      url = "https://www.instagram.com/p/#{@shortcode}/"
      uri = URI::HTTPS.build(
        host: "api.instagram.com",
        path: "/oembed/",
        query: "url=#{url}"
      )
      body = Cache.fetch(uri.to_s) { Request.get(uri) }
      JSON.load(body)
    end
  end
end
