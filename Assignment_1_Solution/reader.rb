# f = File.open('node1.blif')
#
# f.each do |line|
#   puts line.inspect
# end

# f = File.open('node1.eblif')
#
# f.each do |line|
#   next if line.start_with? '.'
#   puts line.inspect
#   puts line.split(' ')[0]
#   puts '- - - - '
# end

# x = [1, 1, 'd']
# y = [1, 0, 'd']
#
# # intersection
# puts 'intersection:'
# puts (x & y).inspect
#
# # union
# puts 'union:'
# puts (x | y).inspect
#
# # difference
# puts 'difference:'
# puts (x - y).inspect

def star(d1, d2)
  if d1 == '0' and d2 == '0'
    return '0'
  elsif d1 == '0' and d2 == '1'
    return 'n'
  elsif d1 == '0' and d2 == 'd'
    return '0'
  elsif d1 == '1' and d2 == '0'
    return 'n'
  elsif d1 == '1' and d2 == '1'
    return '1'  
  elsif d1 == '1' and d2 == 'd'
    return '1'
  elsif d1 == 'd' and d2 == '0'
    return '0'      
  elsif d1 == 'd' and d2 == '1'
    return '1'
  elsif d1 == 'd' and d2 == 'd'
    return 'd'  
  end        
end

def star_operation(cube_1, cube_2)
  result = ''
  # puts cube_1.inspect
  # puts cube_2.inspect
  
  (0...cube_1.length).each do |index|
    # puts star(cube_1[index], cube_2[index])
    result += star(cube_1[index], cube_2[index])
  end
  result
end

def sharp(d1, d2)
  if d1 == '0' and d2 == '0'
    return 'e'
  elsif d1 == '0' and d2 == '1'
    return 'n'
  elsif d1 == '0' and d2 == 'd'
    return 'e'
  elsif d1 == '1' and d2 == '0'
    return 'n'
  elsif d1 == '1' and d2 == '1'
    return 'e'  
  elsif d1 == '1' and d2 == 'd'
    return 'e'
  elsif d1 == 'd' and d2 == '0'
    return '1'      
  elsif d1 == 'd' and d2 == '1'
    return '0'
  elsif d1 == 'd' and d2 == 'd'
    return 'e'  
  end        
end

def sharp_operation(cube_1, cube_2)
  result = ''
  # puts cube_1.inspect
  # puts cube_2.inspect
  
  (0...cube_1.length).each do |index|
    # puts sharp(cube_1[index], cube_2[index])
    result += sharp(cube_1[index], cube_2[index])
  end
  result
end

cube_1 = '10d'
cube_2 = '111'

puts "cube 1: #{cube_1.inspect}"
puts "cube 2: #{cube_2.inspect}"

print 'cube 1 * cube 2: '
puts star_operation(cube_1, cube_2).inspect
print 'cube 1 # cube 2: '
puts sharp_operation(cube_1, cube_2).inspect

puts '- - - - - - - - - - '

cube_1 = 'd1d'
cube_2 = '011'

puts "cube 1: #{cube_1.inspect}"
puts "cube 2: #{cube_2.inspect}"

print 'cube 1 * cube 2: '
puts star_operation(cube_1, cube_2).inspect

print 'cube 1 # cube 2: '
puts sharp_operation(cube_1, cube_2).inspect









