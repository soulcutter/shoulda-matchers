module Shoulda
  module Matchers
    module ActiveModel
      class AllowAttributesMatcher < ValidationMatcher
        def initialize(attributes)
          @attributes = attributes
          @validator = build_validator
        end

        def on(context)
          if context.present?
            @context = context
          end

          self
        end

        def with_message(message, given_options = {})
          if message.present?
            @expects_custom_validation_message = true
            @expected_message = message
            @expected_message_values = given_options.fetch(:values, {})

            if given_options.key?(:against)
              @attribute_to_check_message_against = given_options[:against]
            end
          end

          self
        end

        def matches?(record)
          @record = record
        end

        protected

        attr_reader(
          :attributes,
          :context,
          :expected_message,
          :expected_message_values,
          :expects_custom_validation_message,
          :validator,
        )

        private

        def build_validator
          validator = Validator.new(
            instance,
            attribute_to_check_message_against
          )
          validator.context = context
          validator.expects_strict = expects_strict?
          validator
        end
      end
    end
  end
end
