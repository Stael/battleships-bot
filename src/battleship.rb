require 'rubygems'
require 'json'

#puts ARGV.join(' ')

json = JSON.parse(ARGV.join(' '))

def valid_coordinates(x, y)
  x >= 0 && x < 8 && y >= 0 && y < 8
end

def move_s(x, y)
  x.to_s + y.to_s
end

def shootable(x, y, missed, hit)
  valid_coordinates(x, y) && !missed.include?(move_s(x, y)) && !hit.include?(move_s(x, y))
end

def try_shoot(x, y, missed, hit)
  if shootable(x, y, missed, hit)
    move = {'move' => move_s(x, y), 'shoot' => 'smart'}
    puts JSON.generate move
    true
  else
    false
  end
end

def smart_shoot(json)
  json['hit'].each do |hit|
    x = Integer(hit[0])
    y = Integer(hit[1])

    if try_shoot(x-1, y, json['missed'], json['hit'])
      return true
    end
    if try_shoot(x+1, y, json['missed'], json['hit'])
      return true
    end
    if try_shoot(x, y+1, json['missed'], json['hit'])
      return true
    end
    if try_shoot(x, y-1, json['missed'], json['hit'])
      return true
    end
  end

  false
end

def case_been_shooted(x, y, width, height, hit, missed)
  (x..x+width-1).each { |i|
    (y..y+height-1).each { |j|
      if hit.include?(move_s(i, j)) || missed.include?(move_s(i, j))
        return true
      end
    }
  }

  false
end

def prob_shoot(json)
  width = 2
  height = 2

  until width == 0 || height == 0
    i = 0
    while i < 8
      j = 0
      while j < 8
        unless case_been_shooted(i, j, width, height, json['hit'], json['missed'])
          if width == 2 && height == 2
            if j == 2 || j == 6
              move = {'move' => move_s(i+1, j), 'shoot' => 'probe'}
            else
              move = {'move' => move_s(i, j), 'shoot' => 'probe'}
            end
          else
            move = {'move' => move_s(i, j), 'shoot' => 'probe'}
          end
          puts JSON.generate move
          return true
        end

        j = j+height
      end
      i = i+width
    end

    if height > width
      height -= 1
    else
      width -= 1
    end
  end

  false
end

def random_shoot(json)
  shot_is_valid = false
  until shot_is_valid
    x = rand(8)
    y = rand(8)

    move = move_s(x, y)

    unless json['hit'].include?(move) || json['missed'].include?(move)
      res = {'move' => move, 'shoot' => 'random'}

      puts JSON.generate res
      shot_is_valid = true
    end
  end
end

if json['cmd'] == 'init'
  puts "{\"2\":{\"point\":\"22\",\"orientation\":\"vertical\"},\"3\":{\"point\":\"54\",\"orientation\":\"vertical\"},\"4\":{\"point\":\"47\",\"orientation\":\"horizontal\"},\"5\":{\"point\":\"00\",\"orientation\":\"horizontal\"}}"
else

  unless smart_shoot(json)
    unless prob_shoot(json)
      random_shoot(json)
    end
  end

end