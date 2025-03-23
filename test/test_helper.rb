# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter "/test"
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "access_context"

require "minitest/autorun"
require "debug"
require 'ostruct'

require 'setup_access_context'

class ApplicationTest < Minitest::Spec

end
