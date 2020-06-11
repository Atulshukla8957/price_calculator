class Sale
  @@sale_items = []
  attr_accessor :name, :units, :price

  def initialize(name, units, price)
    @name = name
    @units = units
    @price = price
    @@sale_items << self
  end

  def self.all
    @@sale_items
  end

  def self.in? item_name
    find_by_name(item_name)
  end

  def self.find_by_name(item_name)
    @@sale_items.find { |item| item.name == item_name }
  end

  def price_for_unit
    "#{units} for #{price}"
  end
end

