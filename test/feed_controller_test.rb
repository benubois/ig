require "test_helper"

class FeedControllerTest < Minitest::Test

  def setup
    @request = Request.new
    @response = Response.new
    @server = Server.new
  end

  def test_feed_response
    stub_request(:get, "https://www.instagram.com/username/?__a=1").
    to_return(status: 200, body: '{"key": "value"}')

    controller = FeedController.new(@server)
    controller.do_GET(@request, @response)

    assert_equal(false, @response.keep_alive)
    assert_equal(200, @response.status)
    assert_equal("text/xml", @response.content_type)
    assert(@response.body.include?(
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>"),
      "Output should be XML"
    )
  end

  class Request
    def path
      "/feed"
    end

    def query
      {
        "username" => "username",
        "options" => "option1,option2"
      }
    end
  end

  class Response
    attr_accessor :keep_alive, :status, :content_type, :body
  end

  class Server
    def [](*args)

    end
  end

end