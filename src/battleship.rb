require 'rubygems'
require 'json'

puts ARGV.join(' ')

json = JSON.parse(ARGV.join(' '))

if json['cmd'] == 'init'
  puts '{
        "2" :
        {
            "point": "00",
        "orientation" : "vertical"   // possible values "horizontal", "vertical"
          },
      "3" :
          {
              "point": "22",
              "orientation" : "vertical"
          },
      "4" :
          {
              "point": "42",
              "orientation" : "vertical"
          },
      "5" :
          {
              "point": "37",
              "orientation" : "horizontal"
          }
  }'
else

  shot_is_valid = false
  until shot_is_valid
    x = rand(8)
    y = rand(8)

    move = x.to_s + y.to_s

    unless json['hit'].include?(move) || json['missed'].include?(move)
      res = {'move' => move}

      puts JSON.generate res
      shot_is_valid = true
    end
  end

end