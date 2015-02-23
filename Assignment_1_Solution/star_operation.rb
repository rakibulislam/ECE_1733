require './starter_kit'

class StarOperation
  def self.star(d1, d2)
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

  def self.star_operation(cube_A, cube_B)
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
end
