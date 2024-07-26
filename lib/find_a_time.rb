require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

require_relative "find_a_time/version"

module FindATime
  class Error < StandardError; end
  # Your code goes here...
end
