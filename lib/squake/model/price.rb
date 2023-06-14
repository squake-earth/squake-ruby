# typed: strict
# frozen_string_literal: true

module Squake
  module Model
    class Price < T::Struct
      extend T::Sig

      const :id, String
      const :product, String
      const :unit_amount, BigDecimal
      const :valid_from, T.nilable(Date)
      const :carbon_unit, String
      const :currency, String

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Squake::Model::Price) }
      def self.from_api_response(response_body)
        product = response_body.fetch(:price, {})

        Squake::Model::Price.new(
          id: product.fetch(:id),
          product: product.fetch(:product),
          unit_amount: product.fetch(:unit_amount).to_d,
          valid_from: Date.parse(product.fetch(:valid_from, nil)),
          carbon_unit: product.fetch(:carbon_unit),
          currency: product.fetch(:currency),
        )
      end
    end
  end
end
