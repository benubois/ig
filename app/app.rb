#!/usr/bin/env ruby

require "erb"
require "webrick"
require "json"
require "net/http"
require "uri"

require_relative "./feed"
require_relative "./post"
require_relative "./request"

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

def favicon(request, response)
  response.status = 200
  response.content_type = "image/x-icon"
  response.body = File.read(File.join(File.dirname(__FILE__), "favicon.ico"))
end

class Server < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    response.keep_alive = false
    case request.path
        when "/feed"
            response = feed(request, response)
        when "/favicon.ico"
            response = favicon(request, response)
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
end

server = WEBrick::HTTPServer.new(Port: ENV["PORT"] || 1234)

server.mount "/", Server

trap("INT") {
  server.shutdown
}

server.start
