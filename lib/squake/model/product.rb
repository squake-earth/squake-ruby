# typed: strict
# frozen_string_literal: true

module Squake
  module Model
    class Product < T::Struct
      extend T::Sig

      const :id, String
      const :title, String

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Squake::Model::Product) }
      def self.from_api_response(response_body)
        product = response_body.fetch(:product, {})

        Squake::Model::Product.new(
          id: product.fetch(:id),
          title: product.fetch(:title),
        )
      end
    end
  end
end
