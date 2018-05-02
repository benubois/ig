class FeedController < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    response.keep_alive = false
    case request.path
    when "/feed"
      feed(request, response)
    end
  end

  def feed(request, response)
    if username = request.query["username"]

      request = Request.new(username)
      result = request.result
      feed = Feed.new(username, result)
      body = feed.render

      response.status = 200
      response.content_type = "text/xml"
      response.body = body
    end
  end

end