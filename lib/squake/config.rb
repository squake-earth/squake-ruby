# typed: strict
# frozen_string_literal: true

require 'logger'

module Squake
  class Config < T::Struct
    extend T::Sig

    DEFAULT_BASE_URL = T.let('https://api.squake.earth', String)
    SANDBOX_BASE_URL = T.let('https://api.sandbox.squake.earth', String)

    prop :api_key, T.nilable(String)
    prop :keep_alive_timeout, Integer, default: 30
    prop :logger, ::Logger, factory: -> { ::Logger.new($stdout) }
    prop :sandbox_mode, T::Boolean, default: true
    prop :enforced_api_base, T.nilable(String)

    sig { returns(String) }
    def api_base
      return T.must(enforced_api_base) unless enforced_api_base.nil?

      sandbox_mode ? SANDBOX_BASE_URL : DEFAULT_BASE_URL
    end
  end
end
