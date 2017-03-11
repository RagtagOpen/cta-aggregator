############# Helpers
CAPTURE_INT = Transform(/^(?:-?\d+|zero|one|two|three|four|five|six|seven|eight|nine|ten)$/) do |v|
    %w(zero one two three four five six seven eight nine ten).index(v) || v.to_i
end

def value_to_type(input, expected_type)
  case 
  when expected_type.constantize == DateTime
    DateTime.parse(input)
  when expected_type.constantize == String
    input.to_s
  when expected_type.constantize == Integer
    input.to_i
  when expected_type.constantize == FalseClass
    value_to_boolean(input)
  when expected_type.constantize == TrueClass
    value_to_boolean(input)
  end
end

def value_to_boolean(input)
  (input =~ /true/i) == 0 ? true : false
end
