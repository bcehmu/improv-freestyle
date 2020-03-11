def print_with_pause(str, sleep_time = 0.03)
    chars = str.chars
    chars.each do |c|
      print c # it works with colorize
      sleep(sleep_time) # if sleep_time is a float, the unit is second
    end
    puts ""
  end