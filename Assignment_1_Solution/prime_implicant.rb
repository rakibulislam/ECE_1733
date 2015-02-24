require './star_operation'
require './sharp_operation'

class PrimeImplicant
 def self.generate_final_prime_implicants(on_set, dc_set)
    pi = generate_prime_implicants(on_set + dc_set)
    
    new_pis = []
    pi.each do |p|
      new_pis << p if pi_essential?(p, dc_set)
    end
    new_pis
  end  
  
  def self.calculate_essential_pi_list(current_pi_list, dc_set)
    categorized_pi_list = []
    essential_pi_list = []
    non_essential_pi_list = []
    
    (0...current_pi_list.length).each do |i|
      working_pi_list = current_pi_list.clone + dc_set.clone
      working_pi_list.delete_at(i)  # removing the current PI since it shouldn't be sharped with itself

      if pi_essential?(current_pi_list[i], working_pi_list)
        essential_pi_list.push(current_pi_list[i])
      else
        non_essential_pi_list.push(current_pi_list[i])
      end
    end

    categorized_pi_list.push(essential_pi_list)
    categorized_pi_list.push(non_essential_pi_list)
    categorized_pi_list
  end

  def self.pi_essential?(pi, working_pi_list)
    working_pi_list_index = 0
    is_essential = SharpOperation.chain_sharp(pi, working_pi_list_index, working_pi_list)
    is_essential
  end  

  def self.generate_prime_implicants(initial_cover)
    star_operation_results = []
    (0...initial_cover.length - 1).each do |i|
      (i + 1...initial_cover.length).each do |j|
        star_operation_results << StarOperation.star_operation(initial_cover[i], initial_cover[j])
      end
    end
    star_operation_results += initial_cover # C0 + G1
    star_operation_results = star_operation_results.uniq # remove duplicates
    star_operation_results -= ['NULL'] # remove NULLs

    # remove redundant cubes, outcome is C1 = C0 + G1 - duplicates - redundant cubes
    next_result_set = remove_redundant_cubes(star_operation_results)
    puts "C(k): #{initial_cover}"
    puts "C(k+1): #{next_result_set.uniq}"
    puts "C(k) == C(k+1)?: #{initial_cover.sort == next_result_set.sort}"
    puts '- - - - - - - - - - - - - - - - -'.colorize(:yellow)

    if initial_cover.sort == next_result_set.sort
      return next_result_set
    else
      return generate_prime_implicants(next_result_set)
    end
  end

  def self.remove_redundant_cubes(star_operation_results)
    results = []
    star_operation_results.each do |cube|
      set_of_cubes = star_operation_results - [cube]
      results << cube unless redundant?(cube, set_of_cubes)
    end
    results # only non-redundant cubes
  end

  def self.redundant?(cube, set_of_cubes)
    (0...set_of_cubes.length).each do |i|
      return true if SharpOperation.sharp_operation(cube, set_of_cubes[i]) == ['NULL']
    end
    false
  end
end
