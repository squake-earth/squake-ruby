# typed: strict
# frozen_string_literal: true

module Squake
  class APIError < StandardError
    extend T::Sig

    sig { returns(Squake::Response) }
    attr_reader :response

    sig { params(response: Squake::Response).void }
    def initialize(response:)
      @response = response
      super(T.must(response.error_message))
    end
  end
end
