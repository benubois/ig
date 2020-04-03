class Post
  def initialize(shortcode, username)
    @shortcode = shortcode
    @username = username
  end

  def url
    "https://www.instagram.com/p/#{@shortcode}/"
  end

  def published
    date = Time.now
    date.utc.strftime "%Y-%m-%dT%H:%M:%S%z"
  end

  def id
    @shortcode
  end

  def primary_image_url
    image_src(@shortcode)
  end

  def main_media
    if page.video?
      %(<video src="#{page.video_url}" poster="#{primary_image_url}" />)
    else
      linked_image(@shortcode)
    end
  end

  def gallery
    page.gallery.map { |shortcode| linked_image(shortcode) }.join("\n")
  end

  def html
    "".tap do |string|
      string << %(<p>#{main_media}</p>)
      string << %(<p>#{page.caption}</p>) unless page.caption.empty?
      string << %(<p>#{gallery}</p>) unless gallery.empty?
    end
  end

  def author_name
    page.author_name
  end

  def profile_image_url
    page.profile_image_url
  end

  def valid?
    !page.profile_image_url.nil? && page.profile_image_url != ""
  end

  def item
    {
      id: id,
      content_html: html,
      url: url,
      date_published: published,
      author: {
        name: author_name,
        url: "https://instagram.com/#{@username}",
        avatar: profile_image_url,
        _instagram: {
          username: @username,
        },
      },
    }
  end

  private

  def page
    @page ||= Page.new(@shortcode, @username)
  end

  def linked_image(shortcode)
    %(<a href="#{image_src(shortcode)}"><img src="#{image_src(shortcode)}" /></a>)
  end

  def image_src(shortcode)
    "https://instagram.com/p/#{shortcode}/media/?size=l"
  end
end
