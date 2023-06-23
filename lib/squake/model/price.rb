# typed: strict
# frozen_string_literal: true

module Squake
  module Model
    class Price < T::Struct
      extend T::Sig

      const :id, String
      const :product, String
      const :unit_amount, BigDecimal
      const :valid_from, Date
      const :carbon_unit, String
      const :currency, String

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Squake::Model::Price) }
      def self.from_api_response(response_body)
        Squake::Model::Price.new(
          id: response_body.fetch(:id),
          product: response_body.fetch(:product),
          unit_amount: BigDecimal(response_body.fetch(:unit_amount).to_s),
          valid_from: Date.parse(response_body.fetch(:valid_from)),
          carbon_unit: response_body.fetch(:carbon_unit),
          currency: response_body.fetch(:currency),
        )
      end
    end
  end
end
