class Feed

  def initialize(data, options)
    @data = data
    @options = options
    @template = File.read(File.expand_path('../template.erb', __FILE__))
  end

  def title
    @data.dig("user", "full_name") || @data.dig("user", "username")
  end

  def author
    "@#{@data.dig("user", "username")}"
  end

  def embed?
    @options.include?("embed")
  end

  def posts
    nodes = @data.dig("user", "media", "nodes") || []
    nodes.map do |post|
      Post.new(post)
    end
  end

  def render
    ERB.new(@template).result(binding)
  end

end
