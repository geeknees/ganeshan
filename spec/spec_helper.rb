require "bundler/setup"
require "ganeshan"

require 'simplecov'
require 'simplecov-cobertura'

if ENV['CI']
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  SimpleCov.start
else
  SimpleCov.start do
    enable_coverage :branch
    primary_coverage :branch
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
