# My factory
class Factory
  include Enumerable

  def self.new(*attrs, &block)
    class_name = attrs.shift if attrs[0].is_a? String
    my_struct_class = Class.new(self) do
    # include FactoryInstanceMethodsInitializer.new(*attributes, &init_block)
    # end
    def initialize(*attrs, &block)
      attr_accessor(*attrs)

      define_method :initialize do |*values|
        values.each_with_index { |val, i| send("#{attributes[i]}=", val) }
      end

      define_method :[] do |attribute|
        if attribute.is_a? Numeric
          send("#{attributes[attribute]}")
        else
          send(attribute)
        end
      end

      def each(&value)
        values.each(&value)
      end

      define_method :== do |attribute|
        self.class == attribute.class && self.values == attribute.values
      end

      define_method :[]= do |attribute, value|
        if attribute.is_a? Integer
          raise IndexError unless instance_variables[attribute]
        end
        raise NameError unless instance_variable_get("@#{attribute}")
        instance_variable_set("@#{attribute}", value)
      end

      define_method :to_a do
        values = []
        instance_variables.each do |var|
          values << instance_variable_get(var)
        end
        values
      end

      class_eval(&block) if block_given?

      # redefinition of the method new, so that the heresy did not happen
      # struct_class is a subclass of Factory , so we had to redefine method :new
      my_struct_class.define_singleton_method(:new, Object.method(:new))
      class_name ? const_set(class_name.to_s, my_struct_class) : my_struct_class
    end
  end
  end
end

# Customer = Factory.new(:first_name, :last_name, :address) do
#   def full_name_and_address
#     "#{@first_name} #{@last_name}, #{@address}"
#   end
# end
# # -----------------------------------------------------------------------------
# customer = Customer.new('Jon', 'Snow', 'North, Wall, Black Castle 7')
# # customer = Customer.new('Jon', 'Snow', 'North, Wall, Black Castle 7')
# # puts "Methods: \t"
# # p "Struct_vs_Customer: \n ", Struct.instance_methods - Customer.instance_methods
# # p "Customer_vs_Struct: \n ", Customer.instance_methods - Struct.instance_methods
#
# puts customer
# p Customer.ancestors
# # p Customer.instance_methods
# # p Struct.instance_methods
# puts customer['first_name']
# puts customer[:first_name]
# p customer.full_name_and_address
# p customer.to_s
# # -----------------------------------------------------------------------------
# puts "each {|obj| block } → struct"
# # Customer = Factory.new(:name, :address, :zip)
# joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
# p joe
# joe.each {|x| puts(x) }
# # -----------------------------------------------------------------------------
# puts "struct == other → true or false"
# # Customer = Factory.new(:name, :address, :zip)
# puts joe   = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
# puts joejr = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
# puts jane  = Customer.new("Jane Doe", "456 Elm, Anytown NC", 12345)
# puts joe == joejr   #=> true
# puts joe == jane    #=> false
# # -----------------------------------------------------------------------------
# puts "struct[name] = obj → obj "
# # Attribute Assignment—Sets the value of the given struct member or the
# # member at the given index. Raises NameError if the name does not exist
# # and IndexError if the index is out of range.
# joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
#
# puts joe["name"] = "Luke"
# puts joe[:zip]   = "90210"
#
