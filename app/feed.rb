class Feed

  def initialize(data, options)
    @data = data
    @options = options
    @template = File.read(File.expand_path('../template.erb', __FILE__))
  end

  def title
    @data.dig("graphql", "user", "full_name") || @data.dig("graphql", "user", "username")
  end

  def author
    "@#{@data.dig("graphql", "user", "username")}"
  end

  def embed?
    @options.include?("embed")
  end

  def posts
    nodes = @data.dig("graphql", "user", "edge_owner_to_timeline_media", "edges") || []
    nodes.map do |post|
      Post.new(post)
    end
  end

  def render
    ERB.new(@template).result(binding)
  end

end
