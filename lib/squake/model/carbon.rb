# typed: strict
# frozen_string_literal: true

module Squake
  module Model
    class Carbon < T::Struct
      extend T::Sig

      const :quantity, BigDecimal
      const :unit, Squake::Model::CarbonUnit, default: Squake::Model::CarbonUnit::GRAM
      const :items, T.nilable(T::Array[T::Hash[Symbol, T.untyped]]) # @TODO: resolve to typed items?

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Squake::Model::Carbon) }
      def self.from_api_response(response_body)
        Squake::Model::Carbon.new(
          quantity: BigDecimal(String(response_body.fetch(:quantity))),
          unit: Squake::Model::CarbonUnit.deserialize(response_body.fetch(:unit)),
          items: response_body.fetch(:items, nil),
        )
      end

      sig do
        params(
          unit: Squake::Model::CarbonUnit,
        ).returns(Carbon)
      end
      def in!(unit)
        # this is a bit hacky, but it optimizes memory usages and we don't need `T.must`
        # everywhere if we were to use a prop instead of a const.
        @quantity = Squake::Model::CarbonUnit.convert(quantity, self.unit, to: unit)
        @unit = unit
        self
      end

      sig do
        params(
          other: Carbon,
        ).returns(Carbon)
      end
      def +(other)
        other_qty = Squake::Model::CarbonUnit.convert(other.quantity, other.unit, to: Squake::Model::CarbonUnit::GRAM)
        self_qty = Squake::Model::CarbonUnit.convert(quantity, unit, to: Squake::Model::CarbonUnit::GRAM)

        Carbon.new(quantity: other_qty + self_qty)
      end

      sig { returns(Numeric) }
      def fractional
        quantity.to_f.round(unit.precision)
      end
    end
  end
end
