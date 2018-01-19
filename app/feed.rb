class Feed
  def initialize(json, options)
    @json = json
    @options = options
    @template = File.read(File.join(File.dirname(__FILE__), "template.erb"))
  end

  def title
    "#{@json.dig("user", "full_name")} on Instagram"
  end

  def posts
    @json.dig("user", "media", "nodes").map do |post_json|
      Post.new(post_json, @json, @options)
    end
  end

  def render
    ERB.new(@template).result( binding )
  end
end
