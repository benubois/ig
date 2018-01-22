require "test_helper"

class PostTest < Minitest::Test

  def setup
    @data = {
      "code" => "code",
      "id" => "id",
      "display_src" => "display_src",
      "caption" => "caption",
    }
    @post = Post.new(@data)
  end

  def test_has_url
    assert_equal("https://www.instagram.com/p/#{@data["code"]}/", @post.url)
  end

  def test_has_published
    time = 1516521081
    Time.stub :now, time do
      assert_equal("2018-01-21T07:51:21+0000", @post.published)
    end
  end

  def test_has_id
    assert_equal(@post.id, @data["id"])
  end

  def test_has_display_src
    assert_equal(@post.display_src, @data["display_src"])
  end

  def test_has_caption
    assert_equal(@post.caption, @data["caption"])
  end

  def test_has_video_caption
    data = {
      "caption" => "caption",
      "is_video" => true,
    }
    post = Post.new(data)
    assert_equal(post.caption, "📺 #{data["caption"]}")
  end

end