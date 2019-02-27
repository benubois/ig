class Post

  def initialize(shortcode, username)
    @shortcode = shortcode
    @username = username
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
    post_markup.scan(/<meta.*og:video.*content="(.*)".*/i).flatten.first
  end

  def profile_image_url
    post_markup.scan(/"profile_pic_url":"([^"]+)","username":"#{Regexp.quote(@username)}"/).flatten.first
  end

  def author_name
    name = post_markup.scan(/<meta.*og:title.*content="(.*)/i).flatten.first.split(" on Instagram")
    if name.length > 1
      name.first
    else
      @username
    end
  rescue
    @username
  end

  def media
    if video_url
      %Q(<video src="#{video_url}" poster="#{display_src}" />)
    else
      %Q(<a href="#{display_src}"><img src="#{display_src}" /></a>)
    end
  end

  def html
    %Q(<p>#{media}</p> <p>#{caption}</p>)
  end

  def item
    {
      id: id,
      content_html: html,
      url: url,
      date_published: published,
      author: {
        name: author_name,
        url: "https://instagram.com/#{@username}",
        avatar: profile_image_url,
        _instagram: {
          username: @username
        }
      }
    }
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
        Request.get(uri)
      end
    end

    def oembed
      @oembed ||= begin
        uri = URI::HTTPS.build(
          host: "api.instagram.com",
          path: "/oembed/",
          query: "url=#{url}"
        )
        JSON.load(Request.get(uri))
      end
    end

end