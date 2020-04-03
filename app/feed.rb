require "json"

class Feed
  def initialize(username, shortcodes, request_uri)
    @username = username
    @shortcodes = shortcodes
    @request_uri = request_uri
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
    @posts ||= begin
      @shortcodes.map do |shortcode|
        Post.new(shortcode, @username)
      end
    end
  end

  def items
    posts.map do |post|
      if post.valid?
        post.item
      end
    end.compact
  end

  def render
    JSON.dump({
      version: "https://jsonfeed.org/version/1",
      title: posts.first.author_name,
      home_page_url: "https://instagram.com/#{@username}",
      feed_url: @request_uri.to_s,
      icon: posts.first.profile_image_url,
      items: items,
    })
  end
end
