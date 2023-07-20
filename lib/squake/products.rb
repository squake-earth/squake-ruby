# typed: strict
# frozen_string_literal: true

# https://docs-v2.squake.earth/operation/operation-get-products
module Squake
  class Products
    extend T::Sig

    ENDPOINT = T.let('/v2/products', String)
    DEFAULT_LOCALE = T.let('en', String)

    sig do
      params(
        product_id: T.nilable(String),
        locale: String,
        client: Squake::Client,
        request_id: T.nilable(String),
      ).returns(Squake::Return[T::Array[Squake::Model::Product]])
    end
    def self.get(product_id: nil, locale: DEFAULT_LOCALE, client: Squake::Client.new, request_id: nil)
      path = product_id.nil? ? ENDPOINT : "#{ENDPOINT}/#{product_id}"

      result = client.call(
        path: path,
        method: :get,
        headers: { 'X-Request-Id' => request_id }.compact,
        params: {
          locale: locale,
        },
      )

      if result.success?
        products = T.cast(Array(result.body), T::Array[T::Hash[Symbol, T.untyped]]).map do |product_data|
          Squake::Model::Product.from_api_response(product_data)
        end
        Return.new(result: products)
      else
        error = Squake::Errors::APIErrorResult.new(
          code: :"api_error_#{result.code}",
          detail: result.error_message,
        )
        Return.new(errors: [error])
      end
    end
  end
end
