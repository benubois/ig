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

      shortcodes = Shortcodes.find(username)
      feed = Feed.new(username, shortcodes, request.request_uri)
      body = feed.render

      response.status = 200
      response.content_type = "application/json; charset=utf-8"
      response.body = body
    end
  end

end