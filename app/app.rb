#!/usr/bin/env ruby

$stdout.sync = true

require "erb"
require "uri"
require "json"
require "webrick"
require "net/http"
require "digest"

require_relative "request"
require_relative "feed"
require_relative "post"
require_relative "shortcodes"
require_relative "feed_controller"