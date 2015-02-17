require './starter_kit'
class StarOperation
  def star(d1, d2)
    if d1 == '0' and d2 == '0'
      return '0'
    elsif d1 == '1' and d2 == '1'
      return '1'
    elsif d1 == 'x' and d2 == 'x'
      return 'x'
    elsif (d1 == '0' and d2 == '1') || (d1 == '1' and d2 == '0')
      return 'n'
    elsif (d1 == '0' and d2 == 'x') || (d1 == 'x' and d2 == '0')
      return '0'
    elsif (d1 == '1' and d2 == 'x') || (d1 == 'x' and d2 == '1')
      return '1'
    end
  end

  def star_operation(cube_A, cube_B)
    result = ''
    number_of_nulls = 0

    (0...cube_A.length).each do |index|
      star_of_two_chars = star(cube_A[index], cube_B[index])
      
      if (star_of_two_chars == 'n')
        number_of_nulls += 1
        if number_of_nulls == 1
          # for just one null, the null becomes x         
          result += 'x'
        elsif number_of_nulls > 1
          # for more than one null, the star-operation result becomes null
          return 'NULL'
        end
      else
        # star operation result is not null
        result += star_of_two_chars
      end
    end    
    
    result
  end
#   starter_kit = StarterKit.new
# # read eblif file and set the instance variables after parsing the eblif file
#   starter_kit.read_eblif
#   puts "number_of_inputs: #{starter_kit.number_of_inputs}"
#   puts "number_of_cubes: #{starter_kit.number_of_cubes}"
#   puts "ON_SET: #{starter_kit.on_set}"
#   puts "DC_SET: #{starter_kit.dc_set}"
#   puts "all cubes: #{starter_kit.cubes}"
#   puts "Function cost: #{starter_kit.function_cost(starter_kit.cubes)}"
#   puts '- - - - - - - - - - - - - - - - - - - - - - - - - '
#   puts '- - - - - - - - - - - - - - - - - - - - - - - - - '
#   star = StarOperation.new
#   puts "#{starter_kit.cubes[0]} * #{starter_kit.cubes[1]}: #{star.star_operation(starter_kit.cubes[0], starter_kit.cubes[1])}"
#
#   cube_A = '0x0'
#   cube_B = '1x1'
#   puts "Example 1: #{cube_A} # #{cube_B} = #{star.star_operation(cube_A, cube_B)}"
#
#   cube_A = '0x0'
#   cube_B = 'x11'
#   puts "Example 2: #{cube_A} # #{cube_B} = #{star.star_operation(cube_A, cube_B)}"
end
