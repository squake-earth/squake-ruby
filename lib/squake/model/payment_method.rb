# typed: strict
# frozen_string_literal: true

module Squake
  module Model
    class PaymentMethod < T::Enum
      extend T::Sig

      enums do
        BatchSettlement = new('batch_settlement')
        Stripe = new('stripe')
      end
    end
  end
end
