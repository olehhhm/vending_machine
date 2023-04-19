$stdout.sync = true

def slow_printer str, delay: 0.03
  str.chars.map do |letter|
    print letter
    sleep delay
  end
  print "\n"
end