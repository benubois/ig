#!/usr/bin/env ruby

require "erb"
require "cgi"
require "json"
require "net/http"
require "uri"

require "./feed"
require "./post"
require "./request"

cgi = CGI.new
username = cgi.params["username"].first
request = Request.new(username)
if result = request.result
  feed = Feed.new(result)
  output = feed.render
else
  output = "ERROR"
end

cgi.out("status" => "OK", "type" => "text/xml", "connection" => "close") do
  output
end
