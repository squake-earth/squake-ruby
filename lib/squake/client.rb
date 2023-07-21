# typed: strict
# frozen_string_literal: true

require 'oj'

module Squake
  class Client
    extend T::Sig

    JsonResponseBody = T.type_alias do
      T.any(
        T::Array[T::Hash[Symbol, T.untyped]],
        T::Hash[Symbol, T.untyped],
      )
    end

    sig { params(config: T.nilable(Squake::Config)).void }
    def initialize(config: nil)
      @config = T.let(config || T.must(Squake.configuration), Squake::Config)
    end

    sig do
      params(
        path: String,
        headers: T::Hash[String, String],
        method: Symbol,
        params: T.nilable(T::Hash[Symbol, String]),
        api_base: T.nilable(String),
        api_key: T.nilable(String),
      ).returns(Squake::Response)
    end
    def call(path:, headers: {}, method: :get, params: nil, api_base: nil, api_key: nil)
      execute_request(
        method: method,
        path: path,
        headers: headers,
        params: params,
        api_base: api_base,
        api_key: api_key,
      )
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
    sig do
      params(
        method: Symbol,
        path: String,
        headers: T::Hash[String, String],
        params: T.nilable(T::Hash[Symbol, String]),
        api_base: T.nilable(String),
        api_key: T.nilable(String),
      ).returns(Squake::Response)
    end
    private def execute_request(method:, path:, headers: {}, params: nil, api_base: nil, api_key: nil)
      api_base ||= @config.api_base
      api_key ||= T.must(@config.api_key)

      body_params = nil
      query_params = nil
      case method
      when :get, :head, :delete
        query_params = params
      when :post
        body_params = params
      else
        raise "Unrecognized HTTP method: #{method}. Expected one of: get, head, delete, post"
      end

      headers.merge!(request_headers(api_key))
      query = query_params ? Util.encode_parameters(query_params) : nil
      body = body_params ? ::Oj.dump(body_params) : nil
      sanitized_path = path[0] == '/' ? path : "/#{path}"
      uri = URI.parse(api_base + sanitized_path)

      connection = connection(uri)

      method_name = method.to_s.upcase
      has_response_body = method_name != 'HEAD'
      request = Net::HTTPGenericRequest.new(
        method_name,
        (body_params ? true : false),
        has_response_body,
        (query ? [uri.path, query].join('?') : uri.path),
        headers,
      )

      # https://stripe.com/blog/canonical-log-lines
      canonical_request_line = <<~TXT
        Request started
          http_method=#{request.method}
          http_path=#{request.path}
          http_headers=#{request.to_hash}
      TXT
      canonical_request_line.gsub!(api_key, 'API_KEY_REDACTED')
      @config.logger.info(canonical_request_line)

      result = connection.request(request, body)

      Squake::Response.new(
        original_request: request,
        code: Integer(result.code),
        body: try_parse_json(result.body),
        headers: result.to_hash,
      )
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

    sig { params(api_key: String).returns(T::Hash[String, String]) }
    private def request_headers(api_key)
      {
        'Authorization' => "Bearer #{api_key}",
        'Content-Type' => 'application/json',
      }
    end

    sig { params(result_body: T.untyped).returns(JsonResponseBody) }
    private def try_parse_json(result_body)
      ::Oj.load(result_body, symbol_keys: true)
    rescue ::Oj::ParseError, TypeError, JSON::ParserError, EncodingError => e
      # in case of an error, Squake's response body is HTML not JSON
      { 'error' => { 'message' => e.message, 'body' => result_body } }
    end

    sig { params(uri: URI::Generic).returns(Net::HTTP) }
    private def connection(uri)
      connection = Net::HTTP.new(uri.host, uri.port)
      connection.keep_alive_timeout = @config.keep_alive_timeout
      connection.use_ssl = uri.scheme == 'https'
      connection
    end
  end
end
