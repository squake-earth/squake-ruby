# typed: strict
# frozen_string_literal: true

require 'oj'

module Squake
  class Response < T::Struct
    extend T::Sig

    const :original_request, Net::HTTPGenericRequest
    const :code, Integer
    const :body, Squake::Client::JsonResponseBody
    const :headers, T::Hash[String, T.untyped]

    sig { returns(T::Boolean) }
    def success?
      code >= 200 && code < 300
    end

    sig { returns(T::Boolean) }
    def failure?
      !success?
    end

    sig { returns(T.nilable(Squake::APIError)) }
    def error
      return if success?

      Squake::APIError.new(response: self)
    end

    sig { returns(T.nilable(String)) }
    def error_message
      return if success?

      <<~TXT
        Failed Request
          http_code=#{code}
          body=#{::Oj.dump(body)}
          original_request_http_method=#{original_request.method}
          original_request_http_path=#{original_request.path}
      TXT
    end
  end
end
