require './starter_kit'
class SharpOperation
  def sharp(d1, d2)
    if d1 == '0' and d2 == '0'
      return 'e'
    elsif d1 == '0' and d2 == '1'
      return 'n'
    elsif d1 == '0' and d2 == 'x'
      return 'e'
    elsif d1 == '1' and d2 == '0'
      return 'n'
    elsif d1 == '1' and d2 == '1'
      return 'e'
    elsif d1 == '1' and d2 == 'x'
      return 'e'
    elsif d1 == 'x' and d2 == '0'
      return '1'
    elsif d1 == 'x' and d2 == '1'
      return '0'
    elsif d1 == 'x' and d2 == 'd'
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

  starter_kit = StarterKit.new
# read eblif file and set the instance variables after parsing the eblif file
  starter_kit.read_eblif
  puts "number_of_inputs: #{starter_kit.number_of_inputs}"
  puts "number_of_cubes: #{starter_kit.number_of_cubes}"
  puts "ON_SET: #{starter_kit.on_set}"
  puts "DC_SET: #{starter_kit.dc_set}"
  puts "all cubes: #{starter_kit.cubes}"
  puts "Function cost: #{starter_kit.function_cost(starter_kit.cubes)}"
  puts '-------------'
  puts 'Some example sharp operation:'
  puts
  sharp = SharpOperation.new
  puts "#{starter_kit.cubes[0]} # #{starter_kit.cubes[1]}: #{sharp.sharp_operation(starter_kit.cubes[0], starter_kit.cubes[1])}"
  puts "#{starter_kit.cubes[0]} # #{starter_kit.cubes[2]}: #{sharp.sharp_operation(starter_kit.cubes[0], starter_kit.cubes[2])}"
  puts "#{starter_kit.cubes[0]} # #{starter_kit.cubes[3]}: #{sharp.sharp_operation(starter_kit.cubes[0], starter_kit.cubes[3])}"
  puts "#{starter_kit.cubes[1]} # #{starter_kit.cubes[3]}: #{sharp.sharp_operation(starter_kit.cubes[1], starter_kit.cubes[3])}"
end