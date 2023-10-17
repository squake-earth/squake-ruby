# typed: strict
# frozen_string_literal: true

require_relative 'price'
require_relative 'product'

module Squake
  module Model
    class Pricing < T::Struct
      extend T::Sig

      class Item < T::Struct
        extend T::Sig
        const :carbon_quantity, BigDecimal
        const :carbon_unit, String
        const :distance, BigDecimal
        const :distance_unit, String
        const :external_reference, T.nilable(String)
        const :type, String
        const :methodology, String
      end

      const :id, String
      const :carbon_quantity, BigDecimal
      const :carbon_unit, String
      const :payment_link, T.nilable(String)
      const :price, T.any(Squake::Model::Price, String)
      const :product, T.any(Squake::Model::Product, String)
      const :valid_until, Date
      const :currency, String, default: 'EUR'
      const :total, Integer
      const :items, T::Array[Pricing::Item] # when constructing this, construct nested items first explicitly

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Squake::Model::Pricing) }
      def self.from_api_response(response_body)
        price_or_id = T.let(response_body.fetch(:price), T.any(String, T::Hash[Symbol, T.untyped]))
        price = price_or_id.is_a?(Hash) ? Squake::Model::Price.from_api_response(price_or_id) : price_or_id

        product_or_id = T.let(response_body.fetch(:product), T.any(String, T::Hash[Symbol, T.untyped]))
        product = product_or_id.is_a?(Hash) ? Squake::Model::Product.from_api_response(product_or_id) : product_or_id

        items = response_body.fetch(:items, []) || []
        items.map! do |item|
          item[:carbon_quantity] = item.fetch(:carbon_quantity).to_d
          item[:distance] = item.fetch(:distance).to_d
          Item.new(item)
        end

        Squake::Model::Pricing.new(
          id: response_body.fetch(:id),
          items: items,
          carbon_quantity: BigDecimal(response_body.fetch(:carbon_quantity).to_s),
          carbon_unit: response_body.fetch(:carbon_unit),
          payment_link: response_body.fetch(:payment_link, nil),
          price: price,
          product: product,
          valid_until: Date.parse(response_body.fetch(:valid_until, nil)),
          currency: response_body.fetch(:currency),
          total: response_body.fetch(:total),
        )
      end
    end
  end
end
