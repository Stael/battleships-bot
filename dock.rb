require 'rubygems'
require 'json'

load 'battleship.rb'
load 'grid.rb'
load 'point.rb'

json = JSON.parse(ARGV.join(' '))

if json['cmd'] == 'init'
  puts "{\"2\":{\"point\":\"22\",\"orientation\":\"vertical\"},\"3\":{\"point\":\"53\",\"orientation\":\"vertical\"},\"4\":{\"point\":\"47\",\"orientation\":\"horizontal\"},\"5\":{\"point\":\"00\",\"orientation\":\"horizontal\"}}"
else
  battleship = Battleship.new(json)
  battleship.shoot
end