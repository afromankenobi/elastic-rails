module Elastic
  class NestedType < Types::BaseType
    extend Types::FacetedType

    class << self
      extend Forwardable

      def_delegators :query, :must, :should, :segment, :coord_similarity
    end

    def self.query
      NestedQuery.new self
    end
  end
end
