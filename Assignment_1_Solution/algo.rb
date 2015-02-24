require './prime_implicant'
require 'colorize'

class Algo
  attr_accessor :cover_list
  def initialize
    @working_pi_list = []
    @all_minterms_added_to_cover = false
    @epi_fully_covers_function = false
    @cover_list = []
  end

  def pi_list_fully_cover_function?(minterms, current_cover)
    minterm_coverage_list = get_minterm_function_coverage(minterms, current_cover)
    # the first element contains minterms fully covered
    # the second element contains minterms not fully covered
    minterm_coverage_list[1].length == 0
  end

  # this function calculates if the provided cover completely covers all the minterms/implicants
  def get_minterm_function_coverage(minterms, current_cover)
    minterms_fully_covered = []
    minterms_not_fully_covered = []
    minterm_coverage_list = []
    working_pi_list = current_cover.clone

    (0...minterms.length).each do |i|
      if PrimeImplicant.pi_essential?(minterms[i], working_pi_list)
        minterms_not_fully_covered.push(minterms[i])
      else
        minterms_fully_covered.push(minterms[i])
      end
    end

    minterm_coverage_list.push(minterms_fully_covered)
    minterm_coverage_list.push(minterms_not_fully_covered)
    minterm_coverage_list
    # return (minterms_not_fully_covered.length == 0)
  end

  def generate_pi_combinations(ess_pi_list, non_ess_pi_list)
    pi_list = non_ess_pi_list
    puts "\nNumber of non-essential PIs: #{non_ess_pi_list.length}"
    print "\nFinding Possible Covers using the Branching Algorithm".colorize(:red)
    puts ' . . . . . . . . . . . . '.colorize(:blue).blink
    pi_combinations = []
    pi_combinations.push(ess_pi_list)  # only the essential PIs list a possible combination

    # Adding non-essentials PIs with the essential PI list to generate other possible combination of covers
    (1..pi_list.length).each do |i|
      pi_list.combination(i).to_a.each { |a| pi_combinations << a + ess_pi_list }
    end
    pi_combinations
  end

  def find_all_covers(initial_cover, essential_pi_list, non_essential_pi_list)
    # current_cover = essential_pi_list.clone
    # working_set = non_essential_pi_list.clone
    @cover_list.clear
    check_coverage_combinations(initial_cover, essential_pi_list, non_essential_pi_list)
    # check_coverage_recursion(initial_cover, current_cover, working_set)
    @cover_list
  end

  def check_coverage_combinations(minterms, essential_pi_list, non_essential_pi_list)
    possible_covers = generate_pi_combinations(essential_pi_list, non_essential_pi_list)
    (0...possible_covers.length).each do |i|
      # current_cover = essential_pi_list + possible_covers[i]
      current_cover = possible_covers[i]
      if pi_list_fully_cover_function?(minterms, current_cover)
        @cover_list.push(possible_covers[i])
      end
    end
  end

  def check_coverage_recursion(minterms, current_cover, working_set)
    # current_cover = [p1, p2]
    # working_set = [p3, p4, p5]
    if (working_set.length == 0)
      # all the minterms have been added to cover

      unless @all_minterms_added_to_cover
        @cover_list.push(current_cover)
        @all_minterms_added_to_cover = true
      end

      return
    else
      if pi_list_fully_cover_function?(minterms, current_cover)
        @cover_list.push(current_cover)
        return
      else
        original_working_set = working_set.clone
        original_cover = current_cover.clone

        (0...original_working_set.length).each do |j|
          new_cover = original_cover.clone
          new_working_set = original_working_set.clone

          new_cover.push(new_working_set.delete_at(j))
          # new_cover = [p1, p2, p3]
          # working set = [p4, p5]
          check_coverage_recursion(minterms, new_cover, new_working_set)
        end
        return
      end
    end
  end

  def remove_duplicates(cover_list)
    new_covers = []
    cover_list.each { |cover| new_covers << cover.sort }
    new_covers = new_covers.uniq # removing duplicate covers
    new_covers # returns the covers after removing duplicates
  end

  def find_minimum_cost_cover(cover_list, file_name)
    starter_kit = StarterKit.new(file_name)
    puts "\nFinding the Minimum Cost Cover(s) . . . ".colorize(:green)
    puts
    new_covers = cover_list # with the combination approach, we won't get duplicate covers
    # new_covers = remove_duplicates(cover_list)
    # Finding covers costs and minimum cost cover
    cover_value_hash = Hash.new { |h, k| h[k] = [] }
    new_covers.each do |cover|
      cover_cost = starter_kit.function_cost(cover)
      puts "cost of cover #{cover}: #{cover_cost}".colorize(:light_blue)
      cover_value_hash[cover_cost] << cover
    end
    # puts "cover_value_hash: #{cover_value_hash.inspect}"
    minimum_cost_cover =  cover_value_hash.sort_by { |key, _value| key }

    puts "\nMinimum Cost Cover(s):"
    (0...minimum_cost_cover[0][1].length).each do |i|
      puts "#{minimum_cost_cover[0][1][i]}"
    end
    puts "Number of Minimum Cost Covers: #{minimum_cost_cover[0][1].length}".blue
    puts "Minimum Cost: #{minimum_cost_cover[0][0]}".blue
    puts
    minimum_cost_cover
  end
end
