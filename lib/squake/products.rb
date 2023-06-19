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
        client: Squake::Client,
        locale: String,
        product_id: T.nilable(String),
      ).returns(Squake::Return[T::Array[Squake::Model::Product]])
    end
    def self.get(client:, locale: DEFAULT_LOCALE, product_id: nil)
      path = product_id.nil? ? ENDPOINT : "#{ENDPOINT}/#{product_id}"

      result = client.call(
        path: path,
        method: :get,
        params: {
          locale: locale,
        },
      )

      if result.success?
        products = Array(result.body).map do |product_data|
          Squake::Model::Product.from_api_response({ product: product_data })
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
