require_relative 'factory'

Customer = Factory.new(:name, :address, :zip) do
  def greeting
    "Hello #{name}!"
  end
end
c = Customer.new("Dave", "123 Main")
puts c.name === 'Dave'
puts c.greeting === 'Hello Dave!'


Factory.new("Customer", :name, :address)
c = Factory::Customer.new("Dave", "123 Main")
puts c.address === "123 Main"


joe   = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
joejr = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
jane  = Customer.new("Jane Doe", "456 Elm, Anytown NC", 12345)
puts '_____________==_____________'
puts joe == joejr   #=> true
puts !(joe == jane)    #=> false

jeck = joe
puts '_____________eql?_____________'
puts joe.eql? jeck
puts joe.eql? joejr

puts '_____________[]_____________'
puts joe["name"] == "Joe Smith"  #=> "Joe Smith"
puts joe[:name] == "Joe Smith"  #=> "Joe Smith"
puts joe[0] == "Joe Smith"      #=> "Joe Smith"

puts '_____________[]=_____________'
joe["name"] = "Luke"
joe[:zip]   = 90210
puts joe.name == "Luke" #=> "Luke"
puts joe.zip == 90210  #=> "90210"

puts '_____________each_____________'
arr = []
joe.each {|x| arr.push(x) }
puts arr === ["Luke", "123 Maple, Anytown NC", 90210]

puts '_____________each_pair_____________'
arr = []
joe.each_pair {|name, value| arr.push("#{name} => #{value}") }
puts arr[0] == "name => Luke"
puts arr[1] == "address => 123 Maple, Anytown NC"
puts arr[2] == "zip => 90210"

puts '_____________hash_____________'
puts joe.hash

puts '_____________to_s_____________'
puts joe.to_s

puts '_____________length_____________'
puts joe.length == 3

puts '_____________members_____________'
puts joe.members === [:name, :address, :zip]

puts '_____________select_____________'
Lots = Factory.new(:a, :b, :c, :d, :e, :f)
l = Lots.new(11, 22, 33, 44, 55, 66)
puts l.select {|v| (v % 2).zero? } == [22, 44, 66] #=> [22, 44, 66]

puts '_____________size_____________'
puts joe.size == 3

puts '_____________to_a_____________'
puts joe.to_a == ["Luke", "123 Maple, Anytown NC", 90210]

puts '_____________to_h_____________'
puts joe.to_h == {name: "Luke", address: "123 Maple, Anytown NC", zip: 90210}

puts '_____________values_at_____________'
puts joe.values_at(1...4) == ["Luke", "123 Maple, Anytown NC", 90210]
puts joe.values_at(2, 3) == ["123 Maple, Anytown NC", 90210]
