require './starter_kit'
class SharpOperation
  def sharp(d1, d2)
    if (d1 == '0' and d2 == '0') || (d1 == '1' and d2 == '1') || (d1 == '0' and d2 == 'x') || (d1 == '1' and d2 == 'x') || (d1 == 'x' and d2 == 'x')
      return 'e'
    elsif (d1 == '0' and d2 == '1') || (d1 == '1' and d2 == '0')
      return 'n'
    elsif d1 == 'x' and d2 == '0'
      return '1'
    elsif d1 == 'x' and d2 == '1'
      return '0'
    end
  end

  def sharp_operation(cube_A, cube_B)
    result = ''

    (0...cube_A.length).each do |index|
      result += sharp(cube_A[index], cube_B[index])
    end
    # return C = A if for some i, Ai # Bi = n (null)
    return [cube_A] if result.include? 'n'

    # C = null if for all i, Ai # Bi = e
    return ['NULL'] if all_epsilon?(result)

    differed_indexes = generate_differed_index(cube_A, cube_B)

    new_results = []
    differed_indexes.each do |index|
      temp_result = String.new(cube_A)
      temp_result[index] = compliment(cube_B[index]).to_s
      new_results << temp_result
    end
    new_results.inspect
    new_results
  end

  def compliment(d)
    return 1 if d == '0'
    return 0 if d == '1'
  end

  # check if A is fully covered by B
  def all_epsilon?(result)
    (0...result.length).each do |index|
      return false if result[index] != 'e'
    end
    true
  end

  def generate_differed_index(cube_A, cube_B)
    index = []
    (0...cube_A.length).each do |i|
      index << i if cube_A[i] == 'x' && cube_B[i] != 'x'
    end
    index
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
  puts '- - - - - - - - - - - - - - - - - - - - - - - - - '
  puts '- - - - - - - - - - - - - - - - - - - - - - - - - '
  sharp = SharpOperation.new
  # case: 1
  cube_A = '0x0'
  cube_B = '1x1'
  puts "Case 1 : #{cube_A} # #{cube_B} = #{sharp.sharp_operation(cube_A, cube_B)}" # returns cube_A

  # case: 2
  cube_A = '11x'
  cube_B = 'x1x'
  puts "Case 2 : #{cube_A} # #{cube_B} = #{sharp.sharp_operation(cube_A, cube_B)}" # returns NULL

  # case: 3, example: 1, returns 1 cube
  cube_A = 'x1x'
  cube_B = '11x'
  puts "Case 3: #{cube_A} # #{cube_B} = #{sharp.sharp_operation(cube_A, cube_B)}" # returns one cube

  # case: 3, example: 2, returns array of 2 cubes
  cube_A = 'xx0'
  cube_B = '11x'
  puts "Case 3: #{cube_A} # #{cube_B} = #{sharp.sharp_operation(cube_A, cube_B)}" # returns multiple cubes

  # case: 3, example: 3, returns array of 3 cubes
  cube_A = 'xxx1'
  cube_B = '110x'
  puts "Case 3: #{cube_A} # #{cube_B} = #{sharp.sharp_operation(cube_A, cube_B)}" # returns multiple cubes
  
  # test block
  v1 = sharp.sharp_operation('0x0','01x')
  
  for i in 0...v1.length
    puts "#{v1[i]}"
  end  
  
end
