# # My factory
class Factory
  include Enumerable

  class << self
    def new(*attrs, &block)
      class_name = attrs.shift if (attrs.first.is_a? String)

      define_method :[] do |attr|
        if attr.is_a? Numeric
          raise IndexError unless instance_variables[attr.floor]
          instance_variable_get("@#{members[attr]}")
        elsif attr.is_a? Float
          instance_variable_get("@#{members[attr.to_i]}")
        else
          raise NameError unless members.include?(attr.to_sym)
          instance_variable_get("@#{attr}")
        end
      end

      define_method :[]= do |attr, value|
        if attr.is_a? Integer
          raise IndexError unless instance_variables[attr]
        end
        raise NameError unless instance_variable_get("@#{attr}")
        instance_variable_set("@#{attr}", value)
      end

      define_method :== do |other|
        (self.class == other.class) && (values == other.values)
      end

      define_method :eql? do |other|
        (self.class == other.class) && (values.eql? other.values)
      end

      define_method :to_h do
        attrs.zip(values).to_h
      end

      define_method :length do
        attrs.length
      end
      alias_method :size, :length

      define_method :members do
        attrs
      end

      define_method :each do
        values.each(&block)
      end

      define_method :each_pair do |&block|
        to_h.each_pair(&block)
      end

      define_method :to_a do
        instance_variables.map { |i| instance_variable_get(i) }
      end
      alias_method :values, :to_a

      define_method :dig do |*args|
        to_h.dig(*args)
      end

      define_method :values_at do |*indexes|
        indexes.map do |index|
          raise IndexError unless instance_variables[index]
          to_a[index]
        end
      end

      my_struct_class = Class.new(self) do
        attr_accessor(*attrs, &block)

        define_method :initialize do |*values|
          values.each_with_index { |value, i| send("#{attrs[i]}=", value) }
        end
      end

      class_eval(&block) if block_given?
      my_struct_class.define_singleton_method(:new, Object.method(:new))
      class_name ? const_set(class_name.to_s, my_struct_class) : my_struct_class
    end
  end
end
