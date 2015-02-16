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

  def star_operation(cube_1, cube_2)
    result = ''
    retChar = ''
    countNull = 0
     puts cube_1.inspect
     puts cube_2.inspect

    (0...cube_1.length).each do |index|
      # puts star(cube_1[index], cube_2[index])
      retChar = star(cube_1[index], cube_2[index])
      
      if (retChar == 'n')
        countNull += 1
        
        if countNull == 1
          # for just one null, the null becomes x         
          result +='x'  
        elsif countNull > 1
          # for more than one null, the star-operation result becomes null
          result = 'null'
          break
        end
        
        # return result
        
      else
        # bitwise operation result is not null
        result += retChar
        
      end
      
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
  puts '----------------------------------------------------'
  
  
  # puts 'Some example star operation:'
  star = StarOperation.new
  puts "#{starter_kit.cubes[0]} * #{starter_kit.cubes[1]}: #{star.star_operation(starter_kit.cubes[0], starter_kit.cubes[1])}"
  #puts "#{starter_kit.cubes[0]} * #{starter_kit.cubes[2]}: #{star.star_operation(starter_kit.cubes[0], starter_kit.cubes[2])}"
  #puts "#{starter_kit.cubes[0]} * #{starter_kit.cubes[3]}: #{star.star_operation(starter_kit.cubes[0], starter_kit.cubes[3])}"
  #puts "#{starter_kit.cubes[1]} * #{starter_kit.cubes[3]}: #{star.star_operation(starter_kit.cubes[1], starter_kit.cubes[3])}"
  
  
end
