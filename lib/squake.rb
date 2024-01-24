# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'oj'
require 'uri'
require 'net/http'

Dir[File.join(__dir__, './**/*', '*.rb')].each { |file_path| require(file_path) }

module Squake
  # Don't freeze this constant, since we don't know what Oj is doing with the object under the hood
  # Don't set this as global Oj settings to avoid bleeding into other apps that build on this gem
  # rubocop:disable Style/MutableConstant
  OJ_CONFIG = T.let(
    {
      mode: :compat, # required to dump hashes with symbol-keys
      symbol_keys: true,
    },
    T::Hash[Symbol, T.untyped],
  )
  # rubocop:enable Style/MutableConstant

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

Squake.configure(&:itself) unless ENV['SQUAKE_API_KEY'].nil?
