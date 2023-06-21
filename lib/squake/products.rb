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
        locale: String,
        product_id: T.nilable(String),
        client: Squake::Client,
      ).returns(T::Array[Squake::Model::Product])
    end
    def self.get(locale: DEFAULT_LOCALE, product_id: nil, client: Squake::Client.new)
      path = product_id.nil? ? ENDPOINT : "#{ENDPOINT}/#{product_id}"

      result = client.call(
        path: path,
        method: :get,
        params: {
          locale: locale,
        },
      )
      raise Squake::APIError.new(response: result) unless result.success?

      Array(result.body).map do |product_data|
        Squake::Model::Product.from_api_response({ product: product_data })
      end
    end
  end
end
