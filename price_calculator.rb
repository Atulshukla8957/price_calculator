require 'byebug'
require './sale'
require './item'
require './seed'

class PriceCalculator
  attr_accessor :inputs, :purchased, :quantity, :items_cost

  def initialize
    @inputs = get_input
    @purchased = inputs.split(',').map(&:strip)
  end

  def execute
    if purchased.any?
      @quantity = items_by_quantity
      @items_cost = calculate_bill
      display_result
    else
      puts "Sorry! no items were given"
    end
  end

  private

    def get_input
      display_items
      input = gets.chomp
    end

    def items_by_quantity
      purchased.inject(Hash.new(0)) do |quantity, item_name|
        item = Item.find_by_name(item_name)
        if item
          quantity[item_name] += 1
        end
        quantity
      end
    end

    def calculate_bill
      price = {}
      quantity.each do |item_name, value|
        item = Item.find_by_name(item_name)
        price[item_name] = item.price_calculate(value)
      end
      price
    end

    def display_result
      items = quantity.each_with_object(items_cost) do |(key,val), items|
        items[key] = {units: val, price: items_cost[key]}
      end
      total_price = items.inject(0) do |tot, (item,v)|
        tot + v[:price]
      end

      actual_price = quantity.inject(0) do |tot, (item_name,units)|
        item = Item.find_by_name(item_name)
        tot + (units * item.price)
      end

      puts "Item          Quantity          Price"
      puts "------------------------------------------"

      items.each do |item, v|
        puts "#{item.ljust(20)} #{v[:units]}           $#{v[:price]}"
      end
      puts "Total price : #{total_price.round(3)}"
      puts "You saved #{(actual_price - total_price).round(3)} today."
    end

    def display_items
      puts "Item     Unit price        Sale price"
      puts "------------------------------------------"
      Item.all.each do |item|
        sale_on_item = Sale.find_by_name(item.name)
        puts "#{item.name.ljust(10)}  #{item.price}           #{sale_on_item&.price_for_unit}"
      end
      puts "------------------------------------------"
      puts "Please enter all the items purchased separated by a comma:"
    end
end

pc = PriceCalculator.new
pc.execute
