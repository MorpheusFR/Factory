require_relative 'factory'
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
# customer = Customer.new('Jon', 'Snow', 'North, Wall, Black Castle 7')
# customerStruct = CustomerStruct.new('Jon', 'Snow', 'North, Wall, Black Castle 7')
#
puts "Methods ***************************************: \t"
p "Struct_vs_Customer: \n ", CustomerStruct.instance_methods - Customer.instance_methods

# puts customer
# puts customerStruct
# puts "_________________________________________________________________________"
# p customer.class.ancestors
# p Customer.class.ancestors
# puts "_________________________________________________________________________"
# puts "********************** Instance_methods *****************: \t"
# p customer.class.instance_methods

# puts customer['first_name']
# puts customer[:first_name]
# p customer.full_name_and_address
# p customer.to_s

Customer = Factory.new(:name, :address, :zip)

joe   = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)
joejr = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)
jane  = Customer.new('Jane Doe', '456 Elm, Anytown NC', 99_999)
puts '_____________==_____________'

p joe, joejr, jane
puts joe == joejr
puts joe == jane
puts joe != jane

jeck = joe
puts '_____________eql?_____________'
# p joe, jeck, joejr
puts joe.eql? jeck
puts joe.eql? joejr

puts '_____________[]_____________'
puts joe[0]
puts joe['name']
puts joe[:name]
puts joe['name'] == 'Joe Smith' #=> "Joe Smith"
puts joe[:name] == 'Joe Smith'  #=> "Joe Smith"
puts joe[0] == 'Joe Smith'      #=> "Joe Smith"

puts '_____________[]=_____________'
joe['name'] = 'Luke'
joe[:zip]   = 90_210
puts joe.name == 'Luke' #=> "Luke"
puts joe.zip == 90_210 #=> "90210"

puts '_____________each_____________'
arr = []
joe.each { |x| arr.push(x) }
puts joe.each
puts arr === ['Luke', '123 Maple, Anytown NC', 90_210]

puts '_____________each_pair_____________'
arr = []
joe.each_pair { |name, value| arr.push("#{name} => #{value}") }
puts arr[0] == 'name => Luke'
puts arr[1] == 'address => 123 Maple, Anytown NC'
puts arr[2] == 'zip => 90210'

puts '_____________hash_____________'
puts joe.hash, joejr.hash, jane.hash

puts '_____________to_s_____________'
puts joe.to_s, joejr.to_s, jane.to_s

puts '_____________length_____________'
puts joe.length #== 3

puts '_____________members_____________'
p joe.members
puts joe.members === %i[name address zip]

puts '_____________select_____________'
Lots = Factory.new(:a, :b, :c, :d, :e, :f)
l = Lots.new(11, 22, 33, 44, 55, 66)
puts l.select { |value| (value % 2).zero? } == [22, 44, 66] #=> [22, 44, 66]

puts '_____________size_____________'
puts joe.size == 3

puts '_____________to_a_____________'
puts joe.to_a
puts joe.to_a == ['Luke', '123 Maple, Anytown NC', 90_210]

puts '_____________to_h_____________'
puts joe.to_h == { name: 'Luke', address: '123 Maple, Anytown NC', zip: 90_210 }

puts '_____________dig_____________'
klass = Factory.new(:a)
o = klass.new(klass.new(b: [1, 2, 3]))
p o.dig(:a, :a, :b, 0)              #=> 1
p o.dig(:b, 0)                      #=> nil

puts '_____________values_at_____________'
smith = Customer.new('Jon Snow', 'North, Wall, Black Castle 7', 12_345)
p smith.values_at 0, 2 #=> ["Joe Smith", 12345]
