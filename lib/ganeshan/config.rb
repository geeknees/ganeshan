# frozen_string_literal: true

module Ganeshan
  @enabled = (/\A(1|true)\z/i =~ ENV['GANESH_ENABLED'])

  @logger = Logger.new(ENV['GANESH_LOG'] || $stdout).tap do |logger|
    logger.formatter = lambda do |severity, datetime, _progname, msg|
      "\n#{self}\t#{severity}\t#{datetime}\t#{msg}\n"
    end
  end

  class << self
    attr_accessor :enabled,
                  :logger,
                  :connection
  end
end
