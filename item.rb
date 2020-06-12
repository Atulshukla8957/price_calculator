class Item
  attr_accessor :name, :price
  @@items = []

  def initialize(name, price)
    @name = name
    @price = price
    @@items << self
  end

  def self.all
    @@items
  end

  def self.find_by_name(item_name)
    @@items.find { |item| item.name == item_name }
  end

  def price_calculate(quantity)
    if sale
      (((quantity/sale.units).floor)*sale.price) + ((quantity%sale.units)*price)
    else
      quantity*price
    end
  end

  def sale
    Sale.find_by_name(name)
  end
end
