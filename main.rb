#!/usr/bin/ruby

require_relative 'utils/printer'
require_relative 'utils/string_colorize'
require_relative 'store/products'
require_relative 'services/vending_machine'

AVAILABLE_COINS = [0.25, 0.5, 1, 2, 3, 5].freeze
product_store = Store::Products.new

vending_machine = Services::VendingMachine.new(product_store, AVAILABLE_COINS)

begin
  vending_machine.choose_product
rescue => Exception
  slow_printer "\nOops, something horrible happened. We will restart process.".yellow
  vending_machine.choose_product
end