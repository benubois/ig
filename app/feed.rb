class Feed

  def initialize(username, shortcodes)
    @username = username
    @shortcodes = shortcodes
    @template = File.read(File.expand_path('../template.erb', __FILE__))
  end

  def title
    "@#{@username}"
  end

  def author
    "@#{@username}"
  end

  def embed?
    false
  end

  def posts
    @shortcodes.map do |shortcode|
      Post.new(shortcode)
    end
  end

  def render
    ERB.new(@template).result(binding)
  end

end
