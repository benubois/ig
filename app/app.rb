#!/usr/bin/env ruby

$stdout.sync = true

require "erb"
require "uri"
require "json"
require "webrick"
require "net/http"

require_relative "feed"
require_relative "post"
require_relative "request"
require_relative "feed_controller"

WEBrick::HTTPUtils::DefaultMimeTypes["ico"] = "image/x-icon"

server = WEBrick::HTTPServer.new(
  Port: ENV["PORT"] || 1234,
  DocumentRoot: File.expand_path('../../public', __FILE__)
)

server.mount "/feed", FeedController

["INT", "TERM", "HUP"].each do |signal|
  trap(signal) { server.shutdown }
end

server.start
