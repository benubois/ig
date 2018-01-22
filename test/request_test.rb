require "test_helper"

class RequestTest < Minitest::Test

  def setup
    @request = Request.new("username")
  end

  def test_has_uri
    assert_equal("https://www.instagram.com/username/?__a=1", @request.uri.to_s)
  end

  def test_has_result
    stub_request(:get, "https://www.instagram.com/username/?__a=1").
    to_return(status: 200, body: '{"key": "value"}')
    assert_equal({"key" => "value"}, @request.result)
  end

end