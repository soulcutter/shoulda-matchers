module Shoulda
  module Matchers
    module ActiveModel
      # @private
      module StrictValidator
        def allow_description(allowed_values)
          "doesn't raise when #{attribute} is set to #{allowed_values}"
        end

        def expected_message_from(attribute_message)
          "#{human_attribute_name} #{attribute_message}"
        end

        def formatted_messages
          [messages.first.message]
        end

        def messages_description
          if has_messages?
            "\nFull error message:\n" +
              Shoulda::Matchers.indent(messages.first.message.inspect, 2)
          else
            "(There didn't seem to be an error.)"
          end
        end

        def expected_messages_description(expected_message)
          # description = "validating :#{attribute} to raise a StrictValidationFailed"

          # if expected_message
            # description << ",\nand for the error message to include #{expected_message.inspect}"
          # end

          # description

          "a validation exception should have been raised with a message of #{expected_message.inspect}"
        end

        protected

        def collect_messages
          validation_exceptions
        end

        private

        def validation_exceptions
          record.valid?(context)
          []
        rescue ::ActiveModel::StrictValidationFailed => exception
          [exception]
        end
      end
    end
  end
end
