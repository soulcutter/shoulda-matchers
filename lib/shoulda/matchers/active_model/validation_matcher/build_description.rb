module Shoulda
  module Matchers
    module ActiveModel
      class ValidationMatcher
        # @private
        class BuildDescription
          def self.call(matcher, main_description)
            new(matcher, main_description).call
          end

          def initialize(matcher, main_description)
            @matcher = matcher
            @main_description = main_description
          end

          def call
            if description_clauses_for_qualifiers.any?
              main_description +
                ', ' +
                description_clauses_for_qualifiers.to_sentence
            else
              main_description
            end
          end

          protected

          attr_reader :matcher, :main_description

          private

          def description_clauses_for_qualifiers
            description_clauses = []

            if matcher.try(:allow_nil?)
              description_clauses << 'allowing it to be nil'
            end

            if matcher.try(:strict_validation?)
              description_clauses << 'raising a validation exception'

              if matcher.try(:using_custom_message?)
                description_clauses.last << ' with a custom message'
              end

              description_clauses.last << ' on failure'
            elsif matcher.try(:using_custom_message?)
              description_clauses <<
                'producing a custom validation error on failure'
            end

            description_clauses
          end
        end
      end
    end
  end
end
