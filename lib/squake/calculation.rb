# typed: strict
# frozen_string_literal: true

# https://docs-v2.squake.earth/operation/operation-post-calculations
module Squake
  class Calculation
    extend T::Sig

    ENDPOINT = T.let('/v2/calculations', String)

    sig do
      params(
        client: Squake::Client,
        items: T::Array[Squake::Model::Items::BaseType],
        carbon_unit: String,
        expand: T::Array[String],
      ).returns(Squake::Model::Carbon)
    end
    def self.create(client:, items:, carbon_unit: 'gram', expand: [])
      result = client.call(
        path: ENDPOINT,
        method: :post,
        params: {
          items: items.map(&:serialize),
          carbon_unit: carbon_unit,
          expand: expand,
        },
      )
      raise Squake::APIError.new(response: result) unless result.success?

      Squake::Model::Carbon.from_api_response(
        T.cast(result.body, T::Hash[Symbol, T.untyped]),
      )
    end
  end
end
