require "test_helper"

class FeedTest < Minitest::Test

  def setup

    @data = {
      "logging_page_id" => "profilePage_991793",
      "show_suggested_profiles" => false,
      "graphql" => {
        "user" => {
          "full_name" => "Todd J. Collins",
          "username" => "toddjcollins",
          "edge_owner_to_timeline_media" => {
            "edges" => [
              {
                "node" =>  {
                  "id" =>  "1640317218229258698",
                  "edge_media_to_caption" =>  {
                    "edges" =>  [
                      {
                        "node" => {
                          "text" => "#colorfactoryco"
                        }
                      }
                    ]
                  },
                  "shortcode" => "BbDk9G3gwnK",
                  "display_url" => "https//scontent-sjc3-1.cdninstagram.com/vp/3a5164923413309994bc1944a525626a/5B509147/t51.2885-15/e35/18812227_915116121973012_5341068978225676288_n.jpg",
                  "is_video" => true
                }
              }
            ]
          }
        }
      }
    }


    @feed = Feed.new(@data, ["embed"])
  end

  def test_has_title
    assert_equal("#{@data["graphql"]["user"]["full_name"]}", @feed.title)
  end

  def test_has_author
    assert_equal("@#{@data["graphql"]["user"]["username"]}", @feed.author)
  end

  def test_embed
    assert("Feed#embed should be true", @feed.embed?)
  end

  def test_has_posts
    assert_equal(@data.dig("graphql", "user", "edge_owner_to_timeline_media", "edges").length, @feed.posts.length)
  end

  def test_render
    assert(@feed.render.include?("<?xml version=\"1.0\" encoding=\"utf-8\"?>"), "Output should be XML")
  end

end