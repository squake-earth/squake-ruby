# typed: strict
# frozen_string_literal: true

# https://docs-v2.squake.earth/group/endpoint-combined-calculation-pricing
module Squake
  class CalculationWithPricing
    extend T::Sig

    ENDPOINT = T.let('/v2/calculations-with-pricing', String)

    sig do
      params(
        items: T::Array[T.any(Squake::Model::Items::BaseType, T::Hash[T.any(String, Symbol), T.untyped])],
        product: String,
        currency: String,
        carbon_unit: String,
        expand: T::Array[String],
        client: Squake::Client,
      ).returns(Squake::Model::Pricing)
    end
    def self.quote(items:, product:, currency: 'EUR', carbon_unit: 'gram', expand: [], client: Squake::Client.new)
      # @TODO: add typed objects for all possible items. Until then, we allow either a Hash or a T::Struct
      items = items.map do |item|
        item.is_a?(T::Struct) ? item.serialize : item
      end

      result = client.call(
        path: ENDPOINT,
        method: :post,
        params: {
          items: items,
          product: product,
          currency: currency,
          carbon_unit: carbon_unit,
          expand: expand,
        },
      )
      raise Squake::APIError.new(response: result) unless result.success?

      Squake::Model::Pricing.from_api_response(
        T.cast(result.body, T::Hash[Symbol, T.untyped]),
      )
    end
  end
end
