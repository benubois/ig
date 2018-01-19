class Post
  def initialize(json)
    @json = json
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
    <<-EOD
      <img src="#{@json.dig("display_src")}">
      <p>#{@json.dig("caption")}</p>
    EOD
  end

end