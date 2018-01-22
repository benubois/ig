require "test_helper"

class FeedTest < Minitest::Test

  def setup
    @data = {
      "user" => {
        "full_name" => "Full Name",
        "username" => "username",
        "media" => {
          "nodes" => [{
            "code" => "code",
            "id" => "id",
            "display_src" => "display_src",
            "caption" => "caption",
          }]
        }
      }
    }
    @feed = Feed.new(@data, ["embed"])
  end

  def test_has_title
    assert_equal("#{@data["user"]["full_name"]} on Instagram", @feed.title)
  end

  def test_has_author
    assert_equal("@#{@data["user"]["username"]}", @feed.author)
  end

  def test_embed
    assert("Feed#embed should be true", @feed.embed?)
  end

  def test_has_posts
    assert_equal(@data["user"]["media"]["nodes"].length, @feed.posts.length)
  end

  def test_render
    assert(@feed.render.include?("<?xml version=\"1.0\" encoding=\"utf-8\"?>"), "Output should be XML")
  end

end