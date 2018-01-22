require_relative "app"

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
