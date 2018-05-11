# My factory
class Factory
  def self.new(*attrs)
    # my_struct_class = Class.new(self) do
    Class.new do
      # accessor for all attributes inherited from Class
      attr_accessor(*attrs)
      define_method :initialize do |*params|
        # Calls block with two arguments, the item and its index,
        # for each item in enum.
        params.each_with_index { |param, index|
          self.send "#{attrs[index]}=", param
        }
      end
    end
  end

  # redefinition of the method new, so that the heresy did not happen
  # my_struct_class.define_singleton_method(:new, Object.method(:new))
  # return my_struct_class
end

Customer = Factory.new(:first_name, :last_name, :address) do
  def full_name
    "#{@first_name} #{@last_name}"
  end
end

customer = Customer.new('Jon', 'Snow', 'North, Wall, Black Castle 7')
# customer = Factory.new("Jon", "Snow", "North, Wall, Black Castle 7")

p Customer.instance_methods
puts customer
p Customer.ancestors
puts customer['first_name']
