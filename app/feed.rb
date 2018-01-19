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
    @json.dig("user", "media", "nodes").map do |post|
      Post.new(post)
    end
  end

  def author
    "@#{@json.dig("user", "username")}"
  end

  def embed?
    @options.include?("embed")
  end

  def render
    ERB.new(@template).result(binding)
  end
end
