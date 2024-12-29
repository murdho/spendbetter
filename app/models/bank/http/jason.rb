# JSON parser for converting all hash keys into underscore symbols. For example, +"transactionAmount"+ is transformed
# into +:transaction_amount+.
class Bank::Http::Jason
  class << self
    def parse(str, opts)
      JSON
        .parse(str, opts)
        .then { deep_transform it }
    end

    private
      def deep_transform(element)
        case element
        when Hash
          element
            .transform_keys { it.to_s.underscore.to_sym }
            .transform_values { deep_transform it }
        when Array
          element.map { deep_transform it }
        else
          element
        end
      end
  end
end
