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
    
    if (cube_A == 'NULL')
      return 'NULL'
    end

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
end
