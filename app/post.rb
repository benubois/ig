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
    ""
  end

end