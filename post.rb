class Post
  def initialize(json, feed_json, options)
    @json = json
    @feed_json = feed_json
    @options = options
  end

  def author
    "@#{@feed_json.dig("user", "username")}"
  end

  def url
    "https://www.instagram.com/p/#{@json.dig("code")}/"
  end

  def published
    date = @json.dig("date")
    if date
      date = Time.at(date)
    else
      date = Time.now
    end
    date.utc.strftime '%Y-%m-%dT%H:%M:%S%z'
  end

  def id
    @json.dig("id")
  end

  def content
    if @options.include?("embed")
      embed
    else
      image
    end
  end

  def image
    pre = ""
    if @json.dig("is_video")
      pre += "📺 "
    end
    <<-EOD
      <a href="#{url}"><img src="#{@json.dig("display_src")}"></a>
      <p>#{pre}#{@json.dig("caption")}</p>
    EOD
  end

  def embed
    <<-EOD
    <blockquote class="instagram-media" data-instgrm-captioned data-instgrm-permalink="#{url}" data-instgrm-version="8">
        <img src="#{@json.dig("display_src")}">
        <p>#{@json.dig("caption")}</p>
    </blockquote>
    EOD
  end

end