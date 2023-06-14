# typed: strict
# frozen_string_literal: true

module Squake
  module Model
    class Purchase < T::Struct
      extend T::Sig

      const :id, String
      const :files, T::Array[String] # TODO: optional object, typed?
      const :payment_method, String
      const :state, String
      const :metadata, T::Hash[Symbol, T.untyped], default: {}
      const :checkout_page, T.nilable(T::Hash[Symbol, T.untyped])
      const :carbon_quantity, BigDecimal
      const :carbon_unit, String
      const :total, Integer
      const :currency, String
      const :external_reference, T.nilable(String)

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Squake::Model::Purchase) }
      def self.from_api_response(response_body)
        Squake::Model::Purchase.new(
          id: response_body.fetch(:id),
          files: response_body.fetch(:files),
          payment_method: response_body.fetch(:payment_method),
          state: response_body.fetch(:state),
          metadata: response_body.fetch(:metadata),
          checkout_page: response_body.fetch(:checkout_page, nil),
          carbon_quantity: BigDecimal(response_body.fetch(:carbon_quantity).to_s),
          carbon_unit: response_body.fetch(:carbon_unit),
          total: response_body.fetch(:total),
          currency: response_body.fetch(:currency),
          external_reference: response_body.fetch(:external_reference, nil),
        )
      end
    end
  end
end
