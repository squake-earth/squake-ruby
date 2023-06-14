# typed: strict

module Squake
  module Model
    module Items
      extend T::Helpers

      BaseType = T.type_alias do
        Squake::Model::Items::PrivateJet::Squake
      end
    end
  end
end
