# My factory
class Factory
  # def self.new(*attr)
  _my_struct_class = Class.new(self) do
    # accessor for all attributes inherited from Class
    attr_accessor(*attr)

    define_method(:initialize) do |*params|
    end
  end

  # redefinition of the method new, so that the heresy did not happen
  my_struct_class.define_singleton_method(:new, Object.method(:new))
  return my_struct_class
end
