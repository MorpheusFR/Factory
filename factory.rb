# # My factory
class Factory
  include Enumerable

  class << self
    def new(*attrs, &block)
      class_name = attrs.shift if attrs[0].is_a?(String)

      define_method :[] do |attribute|
        if attribute.is_a? Numeric
          send("#{attrs[attribute]}")
        else
          send(attribute)
        end
      end

      my_struct_class = Class.new(self) do
        attr_accessor(*attrs)

        define_method :initialize do |*values|
          values.each_with_index { |value, i| send("#{attrs[i]}=", value) }
        end
      end

      class_eval(&block) if block_given?
      # my_struct_class is a subclass of Factory , so we had to redefine method :new
      my_struct_class.define_singleton_method(:new, Object.method(:new))
      class_name ? const_set(class_name.to_s, my_struct_class) : my_struct_class
    end
  end
end

# ----------------------------------TEST----------------------------------------
Customer = Factory.new(:first_name, :last_name, :zip) do
  def full_name_and_address
    "#{@first_name} #{@last_name}, #{@zip}"
  end
end

CustomerStruct = Struct.new(:first_name, :last_name, :zip) do
  def full_name_and_address
    "#{@first_name} #{@last_name}, #{@zip}"
  end
end
# -----------------------------------------------------------------------------
customer = Customer.new('Jon', 'Snow', 'North, Wall, Black Castle 7')
customerStruct = CustomerStruct.new('Jon', 'Snow', 'North, Wall, Black Castle 7')

puts "Methods ***************************************: \t"
p "Struct_vs_Customer: \n ", CustomerStruct.instance_methods - Customer.instance_methods

puts customer
puts customerStruct
puts "_________________________________________________________________________"
p customer.class.ancestors
p Customer.class.ancestors
puts "_________________________________________________________________________"
puts "********************** Instance_methods *****************: \t"
p customer.class.instance_methods

puts customer['first_name']
puts customer[:first_name]
p customer.full_name_and_address
p customer.to_s
