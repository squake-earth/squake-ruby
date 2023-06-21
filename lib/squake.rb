# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'oj'
require 'net/http'

Dir[File.join(__dir__, './**/*', '*.rb')].each { require(_1) }

module Squake
  class << self
    extend T::Sig

    sig { returns(T.nilable(Squake::Config)) }
    attr_accessor :configuration

    sig do
      params(
        _: T.proc.params(configuration: Squake::Config).void,
      ).void
    end
    def configure(&_)
      self.configuration ||= Squake::Config.new(
        api_key: ENV.fetch('SQUAKE_API_KEY', nil),
        keep_alive_timeout: ENV.fetch('SQUAKE_KEEP_ALIVE_TIMEOUT', 30).to_i,
        sandbox_mode: ENV.fetch('SQUAKE_SANDBOX_MODE', 'true').casecmp?('true'),
        enforced_api_base: ENV.fetch('SQUAKE_API_BASE', nil),
      )

      yield(T.must(configuration))
    end
  end
end

Oj.default_options = {
  mode: :compat, # required to dump hashes with symbol-keys
  symbol_keys: true,
}
