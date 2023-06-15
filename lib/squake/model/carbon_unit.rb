# typed: strict
# frozen_string_literal: true

# as per International System of Units ("SI", or "metric system")
# see: https://www.nist.gov/pml/owm/si-units-mass
module Squake
  module Model
    class CarbonUnit < T::Enum
      extend T::Sig

      enums do
        GRAM     = new('gram')
        KILOGRAM = new('kilogram')
        TONNE    = new('tonne')
      end

      sig { returns(String) }
      def serialize_to_abbreviation
        case self
        when CarbonUnit::GRAM     then 'g'
        when CarbonUnit::KILOGRAM then 'kg'
        when CarbonUnit::TONNE    then 't'
        else
          T.absurd(self)
        end
      end

      sig do
        params(
          carbon_quantity: T.any(Integer, Float, Rational, BigDecimal),
          carbon_unit: CarbonUnit,
          to: CarbonUnit,
        ).returns(BigDecimal)
      end
      def self.convert(carbon_quantity, carbon_unit, to: CarbonUnit::GRAM)
        case carbon_unit
        when CarbonUnit::GRAM     then gram_to_unit(carbon_quantity, to)
        when CarbonUnit::KILOGRAM then kilogram_to_unit(carbon_quantity, to)
        when CarbonUnit::TONNE    then tonne_to_unit(carbon_quantity, to)
        else
          T.absurd(carbon_unit)
        end
      end

      sig { returns(Integer) }
      def precision
        case self
        when CarbonUnit::GRAM     then 0
        when CarbonUnit::KILOGRAM then 3
        when CarbonUnit::TONNE    then 6
        else
          T.absurd(self)
        end
      end

      sig do
        params(
          carbon_quantity: T.any(Integer, Float, Rational, BigDecimal),
          to: CarbonUnit,
        ).returns(BigDecimal)
      end
      private_class_method def self.gram_to_unit(carbon_quantity, to)
        case to
        when CarbonUnit::GRAM     then BigDecimal(carbon_quantity)
        when CarbonUnit::KILOGRAM then BigDecimal(carbon_quantity) / 1_000
        when CarbonUnit::TONNE    then BigDecimal(carbon_quantity) / 1_000_000
        else
          T.absurd(to)
        end
      end

      sig do
        params(
          carbon_quantity: T.any(Integer, Float, Rational, BigDecimal),
          to: CarbonUnit,
        ).returns(BigDecimal)
      end
      private_class_method def self.kilogram_to_unit(carbon_quantity, to)
        case to
        when CarbonUnit::GRAM     then BigDecimal(carbon_quantity) * 1_000
        when CarbonUnit::KILOGRAM then BigDecimal(carbon_quantity)
        when CarbonUnit::TONNE    then BigDecimal(carbon_quantity) / 1_000
        else
          T.absurd(to)
        end
      end

      sig do
        params(
          carbon_quantity: T.any(Integer, Float, Rational, BigDecimal),
          to: CarbonUnit,
        ).returns(BigDecimal)
      end
      private_class_method def self.tonne_to_unit(carbon_quantity, to)
        case to
        when CarbonUnit::GRAM     then BigDecimal(carbon_quantity) * 1_000_000
        when CarbonUnit::KILOGRAM then BigDecimal(carbon_quantity) * 1_000
        when CarbonUnit::TONNE    then BigDecimal(carbon_quantity)
        else
          T.absurd(to)
        end
      end
    end
  end
end
