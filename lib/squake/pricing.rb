# typed: strict
# frozen_string_literal: true

# https://docs-v2.squake.earth/group/endpoint-combined-calculation-pricing
module Squake
  class Pricing
    extend T::Sig

    ENDPOINT = T.let('/v2/pricing', String)

    sig do
      params(
        product_id: String,
        fixed_total: T.nilable(Numeric),
        currency: String,
        carbon_quantity: T.nilable(Numeric),
        carbon_unit: T.nilable(String),
        expand: T::Array[String],
        client: Squake::Client,
        request_id: T.nilable(String),
      ).returns(Squake::Return[Squake::Model::Pricing])
    end
    def self.quote(
      product_id:, fixed_total: nil, currency: 'EUR', carbon_quantity: nil, carbon_unit: 'gram',
      expand: [], client: Squake::Client.new, request_id: nil
    )

      result = client.call(
        path: ENDPOINT,
        method: :get,
        headers: { 'X-Request-Id' => request_id }.compact,
        params: {
          product: product_id,
          fixed_total: fixed_total,
          currency: currency,
          carbon_quantity: carbon_quantity,
          carbon_unit: carbon_unit,
          expand: expand,
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
