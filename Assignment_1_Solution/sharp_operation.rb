require './starter_kit'

class SharpOperation
  def self.sharp(d1, d2)
    if (d2 == 'x')
      return 'e'
    elsif (d1 == d2) # i.e cases (d1 == '0' && d2 == '0') || (d1 == '1' && d2 == '1') 
      return 'e'
    elsif (d1 == '0' && d2 == '1') || (d1 == '1' && d2 == '0')
      return 'n'
    elsif d1 == 'x' && d2 == '0'
      return '1'
    elsif d1 == 'x' && d2 == '1'
      return '0'
    end
  end

  def self.sharp_operation(cube_A, cube_B)
    result = ''
    return ['NULL'] if cube_A == 'NULL'

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
    new_results
  end

  def self.chain_sharp(result, current_index, working_pi_list)
    is_essential = false
    if current_index >= working_pi_list.length
      # iteration done
      return result != 'NULL'
    else
      if result == 'NULL'
        return false
      else
        new_result = SharpOperation.sharp_operation(result, working_pi_list[current_index])
        (0...new_result.length).each do |i|
          if new_result[i] != 'NULL'
            is_essential ||= chain_sharp(new_result[i], current_index + 1, working_pi_list)
          end
        end
        return is_essential
      end
    end
  end
  
  def self.compliment(d)
    return 1 if d == '0'
    return 0 if d == '1'
  end

  # check if A is fully covered by B
  def self.all_epsilon?(result)
    (0...result.length).each do |index|
      return false if result[index] != 'e'
    end
    true
  end

  def self.generate_differed_index(cube_A, cube_B)
    index = []
    (0...cube_A.length).each do |i|
      index << i if cube_A[i] == 'x' && cube_B[i] != 'x'
    end
    index
  end
end
