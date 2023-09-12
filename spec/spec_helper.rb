# typed: false
# frozen_string_literal: true

require 'squake'
require 'byebug'
require 'vcr'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  VCR.configure do |vcr_config|
    vcr_config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    vcr_config.hook_into :webmock
    vcr_config.configure_rspec_metadata!
  end
end

SQUAKE_API_KEY = 'MOCK_API_KEY'
def squake_client
  config = Squake::Config.new(api_key: SQUAKE_API_KEY)
  Squake::Client.new(config: config)
end
