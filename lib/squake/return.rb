# typed: strict
# frozen_string_literal: true

require_relative 'errors/api_error_result'

module Squake
  class Return
    class Failure < StandardError; end

    FAILURE_MSG_NO_ARGS = 'Must provide either a result or errors'
    FAILURE_MSG_BOTH_ARGS = 'Cannot provide both a result and errors'
    FAILURE_ERRORS_CALLED_WHEN_SUCCESS = 'Cannot call errors when result is present'

    extend T::Sig
    extend T::Generic

    Error = type_member { { fixed: Errors::APIErrorResult } }
    Result = type_member { { upper: Object } }

    sig { params(result: T.nilable(Result), errors: T.nilable(T::Array[Error])).void }
    def initialize(result: nil, errors: nil)
      raise Failure, FAILURE_MSG_NO_ARGS if result.nil? && errors.nil?
      raise Failure, FAILURE_MSG_BOTH_ARGS if present?(result) && present?(errors)

      @result = result
      @errors = errors
    end

    sig { returns(T::Boolean) }
    def success?
      blank?(@errors)
    end

    sig { returns(T::Boolean) }
    def failed?
      !success?
    end

    sig { returns(T::Array[Error]) }
    def errors
      raise Failure, FAILURE_ERRORS_CALLED_WHEN_SUCCESS if success?

      T.must(@errors)
    end

    sig { returns(Result) }
    def result
      raise Failure, @errors&.map(&:serialize) if failed?

      T.must(@result)
    end

    # courtesy to Rails, see: https://api.rubyonrails.org/v7.0.5/classes/Object.html
    sig { params(object: T.untyped).returns(T::Boolean) }
    private def blank?(object)
      object.respond_to?(:empty?) ? !!object.empty? : !object
    end

    sig { params(object: T.untyped).returns(T::Boolean) }
    private def present?(object)
      !blank?(object)
    end
  end
end
