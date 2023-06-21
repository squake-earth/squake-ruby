# typed: strict
# frozen_string_literal: true

module Squake
  module Errors
    class APIErrorSource < T::Struct
      const :attribute, T.any(Symbol, String)
      const :model, T.nilable(String), default: nil
      const :id, T.nilable(String), default: nil # external reference if given
    end
  end
end
