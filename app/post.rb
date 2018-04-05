class Post

  def initialize(data)
    @data = data
  end

  def url
    "https://www.instagram.com/p/#{@data.dig("node", "shortcode")}/"
  end

  def published
    date = @data.dig("node", "taken_at_timestamp") || Time.now.to_i
    date = Time.at(date)
    date.utc.strftime '%Y-%m-%dT%H:%M:%S%z'
  end

  def id
    @data.dig("node", "id")
  end

  def display_src
    @data.dig("node", "display_url")
  end

  def caption
    text = @data.dig("node", "edge_media_to_caption", "edges", 0, "node", "text")
    if @data.dig("node", "is_video")
      text = "📺 #{text}"
    end
    text
  end

end