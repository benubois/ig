$LOAD_PATH.unshift File.expand_path("../../app", __FILE__)

require "coveralls"
Coveralls.wear!

require "minitest/autorun"
require 'webmock/minitest'

require "app"