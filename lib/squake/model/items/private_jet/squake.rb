# typed: strict

module Squake
  module Model
    module Items
      module PrivateJet
        class Squake < T::Struct
          extend T::Sig

          const :type, String, default: 'private_jet'
          const :methodology, String, default: 'SQUAKE'
          const :origin, String
          const :destination, String
          const :identifier, String
          const :identifier_kind, String, default: 'ICAO'
          const :external_reference, T.nilable(String)
        end
      end
    end
  end
end
