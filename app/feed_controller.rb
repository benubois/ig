class FeedController < WEBrick::HTTPServlet::AbstractServlet

  def do_GET (request, response)
    response.keep_alive = false
    case request.path
    when "/feed"
      feed(request, response)
    end
  rescue => exception
    puts "------------------------"
    puts exception.inspect
    puts exception.backtrace.inspect
    puts "------------------------"
    response.status = 500
    response.content_type = "text/plain"
    response.body = "ERROR"
  end

  def feed(request, response)
    if username = request.query["username"]
      options = request.query["options"]
      options = options ? options.split(",") : []

      request = Request.new(username)
      result = request.result
      feed = Feed.new(result, options)
      body = feed.render

      response.status = 200
      response.content_type = "text/xml"
      response.body = body
    end
  end

end