class Post

  def initialize(data)
    @data = data
  end

  def url
    "https://www.instagram.com/p/#{@data.dig("code")}/"
  end

  def published
    date = @data.dig("date") || Time.now.to_i
    date = Time.at(date)
    date.utc.strftime '%Y-%m-%dT%H:%M:%S%z'
  end

  def id
    @data.dig("id")
  end

  def display_src
    @data.dig("display_src")
  end

  def caption
    if @data.dig("is_video")
      "📺 #{@data.dig("caption")}"
    else
      @data.dig("caption")
    end
  end

end