# typed: strict
# frozen_string_literal: true

module Squake
  module Model
    class Product < T::Struct
      extend T::Sig

      const :id, String
      const :title, String
      const :certifications, T::Array[String], default: []

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Squake::Model::Product) }
      def self.from_api_response(response_body)
        Squake::Model::Product.new(
          id: response_body.fetch(:id),
          title: response_body.fetch(:title),
          certifications: response_body.fetch(:certifications, []),
        )
      end
    end
  end
end
