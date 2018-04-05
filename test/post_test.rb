require "test_helper"

class PostTest < Minitest::Test

  def setup
    @data = {
      "node" =>  {
        "id" =>  "id",
        "edge_media_to_caption" =>  {
          "edges" =>  [
            {
              "node" => {
                "text" => "caption"
              }
            }
          ]
        },
        "taken_at_timestamp" => 1522902179,
        "shortcode" => "shortcode",
        "display_url" => "display_url",
        "is_video" => false
      }
    }

    @post = Post.new(@data)
  end

  def test_has_url
    assert_equal("https://www.instagram.com/p/shortcode/", @post.url)
  end

  def test_has_published
    assert_equal("2018-04-05T04:22:59+0000", @post.published)
  end

  def test_has_id
    assert_equal(@post.id, "id")
  end

  def test_has_display_src
    assert_equal(@post.display_src, "display_url")
  end

  def test_has_caption
    assert_equal(@post.caption, "caption")
  end

  def test_has_video_caption
    @data["node"]["is_video"] = true
    post = Post.new(@data)
    assert_equal(post.caption, "📺 #{"caption"}")
  end

end