#!/usr/bin/env ruby

require 'csv'

CSV.foreach('machine-readable.csv', headers: true) do |row|
  puts row['Series_reference']
  puts row['Period']
  puts row['Data_value']
  break
end
