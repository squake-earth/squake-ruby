# typed: strict
# frozen_string_literal: true

require_relative 'api_error_source'

module Squake
  module Errors
    #
    # https://jsonapi.org/format/#errors
    #
    # > Error objects MUST be returned as an array keyed by errors in the top level of a JSON:API document.
    #
    class APIErrorResult < T::Struct
      const :code, Symbol # An application-specific error code

      # A human-readable explanation specific to this occurrence of the problem.
      # Like title, this field's value can be localized.
      const :detail, T.nilable(String)
      const :source, T.nilable(APIErrorSource)
    end
  end
end
