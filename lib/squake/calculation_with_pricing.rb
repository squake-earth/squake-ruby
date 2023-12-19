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
        payment_link_return_url: T.nilable(String),
        client: Squake::Client,
        request_id: T.nilable(String),
      ).returns(Squake::Return[Squake::Model::Pricing])
    end
    def self.quote(
      items:, product:, currency: 'EUR', carbon_unit: 'gram',
      expand: [], payment_link_return_url: nil, client: Squake::Client.new, request_id: nil
    )
      # @TODO: add typed objects for all possible items. Until then, we allow either a Hash or a T::Struct
      items = items.map do |item|
        item.is_a?(T::Struct) ? item.serialize : item
      end

      result = client.call(
        path: ENDPOINT,
        method: :post,
        headers: { 'X-Request-Id' => request_id }.compact,
        params: {
          items: items,
          product: product,
          currency: currency,
          carbon_unit: carbon_unit,
          expand: expand,
          payment_link_return_url: payment_link_return_url,
        },
      )

      if result.success?
        pricing = Squake::Model::Pricing.from_api_response(
          T.cast(result.body, T::Hash[Symbol, T.untyped]),
        )
        Return.new(result: pricing)
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
