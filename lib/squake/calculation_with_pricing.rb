# typed: strict
# frozen_string_literal: true

# https://docs-v2.squake.earth/group/endpoint-combined-calculation-pricing
module Squake
  class CalculationWithPricing
    extend T::Sig

    ENDPOINT = T.let('/v2/calculations-with-pricing', String)

    sig do
      params(
        client: Squake::Client,
        items: T::Array[Squake::Model::Items::BaseType],
        product: String,
        currency: String,
        carbon_unit: String,
        expand: T::Array[String],
      ).returns(Squake::Model::Pricing)
    end
    def self.quote(client:, items:, product:, currency: 'EUR', carbon_unit: 'gram', expand: [])
      result = client.call(
        path: ENDPOINT,
        method: :post,
        params: {
          items: items.map(&:serialize),
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
