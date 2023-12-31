# typed: strict
# frozen_string_literal: true

# https://docs-v2.squake.earth/operation/operation-post-purchases
module Squake
  class Purchase
    extend T::Sig

    ENDPOINT = T.let('/v2/purchases', String)

    sig do
      params(
        pricing: String,
        confirmation_document: T.nilable(T::Hash[Symbol, T.untyped]),
        certificate_document: T.nilable(T::Hash[Symbol, T.untyped]),
        metadata: T.nilable(T::Hash[Symbol, T.untyped]),
        external_reference: String, # used for idempotency, if given, MUST be unique
        expand: T::Array[String],
        client: Squake::Client,
        request_id: T.nilable(String),
      ).returns(Squake::Return[Squake::Model::Purchase])
    end
    def self.create(
      pricing:, confirmation_document: nil, certificate_document: nil, metadata: nil,
      external_reference: SecureRandom.uuid, expand: [], client: Squake::Client.new, request_id: nil
    )
      result = client.call(
        path: ENDPOINT,
        method: :post,
        headers: { 'X-Request-Id' => request_id }.compact,
        params: {
          pricing: pricing,
          confirmation_document: confirmation_document,
          certificate_document: certificate_document,
          metadata: metadata,
          external_reference: external_reference,
          expand: expand,
        },
      )

      if result.success?
        purchase = Squake::Model::Purchase.from_api_response(
          T.cast(result.body, T::Hash[Symbol, T.untyped]),
        )
        Return.new(result: purchase)
      else
        error = Squake::Errors::APIErrorResult.new(
          code: :"api_error_#{result.code}",
          detail: result.error_message,
        )
        Return.new(errors: [error])
      end
    end

    sig do
      params(
        id: String,
        client: Squake::Client,
      ).returns(T.nilable(Squake::Return[Squake::Model::Purchase]))
    end
    def self.retrieve(id:, client: Squake::Client.new)
      result = client.call(
        path: "#{ENDPOINT}/#{id}",
      )
      return nil if result.code == 404

      if result.success?
        purchase = Squake::Model::Purchase.from_api_response(
          T.cast(result.body, T::Hash[Symbol, T.untyped]),
        )
        Return.new(result: purchase)
      else
        error = Squake::Errors::APIErrorResult.new(
          code: :"api_error_#{result.code}",
          detail: result.error_message,
        )
        Return.new(errors: [error])
      end
    end

    sig do
      params(
        id: String,
        client: Squake::Client,
      ).returns(T.nilable(Squake::Return[Squake::Model::Purchase]))
    end
    def self.cancel(id:, client: Squake::Client.new)
      result = client.call(
        path: "#{ENDPOINT}/#{id}/cancel",
        method: :post,
      )
      return nil if result.code == 404

      if result.success?
        purchase = Squake::Model::Purchase.from_api_response(
          T.cast(result.body, T::Hash[Symbol, T.untyped]),
        )
        Return.new(result: purchase)
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
