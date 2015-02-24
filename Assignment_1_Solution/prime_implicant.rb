require './star_operation'
require './sharp_operation'

class PrimeImplicant

  def generate_prime_implicants(initial_cover)
    start_operation_results = []
    (0...initial_cover.length - 1).each do |i|
      (i + 1...initial_cover.length).each do |j|
        start_operation_results << StarOperation.star_operation(initial_cover[i], initial_cover[j])
      end
    end
    start_operation_results = start_operation_results + initial_cover # C0 + G1
    start_operation_results = start_operation_results.uniq # remove duplicates
    start_operation_results = start_operation_results - ['NULL'] # remove NULLs

    next_result_set = remove_redundant_cubes(start_operation_results) # remove redundant cubes, outcome is C1 = C0 + G1 - duplicates - redundant cubes
    puts "C(k): #{initial_cover}"
    puts "C(k+1): #{next_result_set.uniq}"
    print 'C(k) == C(k+1)?: '
    puts initial_cover.sort == next_result_set.sort
    puts "- - - - - - - - - - - - - -".colorize(:yellow)
    if initial_cover.sort == next_result_set.sort
      return next_result_set
    else
      return generate_prime_implicants(next_result_set)
    end
  end

  def remove_redundant_cubes(start_operation_results)
    results = []
    start_operation_results.each do |cube|
      set_of_cubes = start_operation_results - [cube]
      results << cube unless redundant?(cube, set_of_cubes)
    end
    results # only non-redundant cubes
  end

  def redundant? (cube, set_of_cubes)
    (0...set_of_cubes.length).each do |i|
      return true if SharpOperation.sharp_operation(cube, set_of_cubes[i]) == ['NULL']
    end
    false
  end

  def generate_final_prime_implicants(on_set, dc_set)
    pi = generate_prime_implicants(on_set + dc_set)
    algo = Algo.new
    new_pis = []
    pi.each do |p|
      new_pis << p if algo.pi_essential?(p, dc_set)
    end
    new_pis
  end
end
