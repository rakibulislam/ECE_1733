require './prime_implicant'
require 'pry'
require 'colorize'

class Algo
  attr_accessor :essential_pi_list, :non_essential_pi_list, :cover_list
  def initialize
    @pi_list = []
    @essential_pi_list = []
    @non_essential_pi_list = []
    @working_pi_list = []
    @initial_cover = []
    @all_minterms_added_to_cover = false
    @epi_fully_covers_function = false
    @cover_list = []
  end

  def calculate_essential_pi_list(current_pi_list, dc_set)
    categorized_pi_list = []
    working_pi_list = []
    (0...current_pi_list.length).each do |i|

      working_pi_list = current_pi_list.clone + dc_set.clone
      working_pi_list.delete_at(i)  #removing the current PI since it shouldn't be sharped with itself

      if is_PI_Essential( current_pi_list[i], working_pi_list)
      @essential_pi_list.push( current_pi_list[i])
      else
      @non_essential_pi_list.push( current_pi_list[i])
      end
    end

    categorized_pi_list.push(@essential_pi_list)
    categorized_pi_list.push(@non_essential_pi_list)
    categorized_pi_list
  end

  def does_pi_list_fully_cover_function(minterms, current_cover)
    minterm_coverage_list = []
    minterm_coverage_list = get_minterm_function_coverage(minterms, current_cover)
    # the first element contains minterms fully covered
    # the second element contains minterms not fully covered
    return (minterm_coverage_list[1].length == 0)
  end

  # this function calculates if the provided cover completely covers all the minterms/implicants
  def get_minterm_function_coverage(minterms, current_cover)
    minterms_fully_covered = []
    minterms_not_fully_covered = []

    minterm_coverage_list = []

    working_pi_list = current_cover.clone

    (0...minterms.length).each do |i|

      if is_PI_Essential( minterms[i], working_pi_list)
      minterms_not_fully_covered.push( minterms[i])
      else
      minterms_fully_covered.push( minterms[i])
      end
    end

    minterm_coverage_list.push(minterms_fully_covered)
    minterm_coverage_list.push(minterms_not_fully_covered)

    return minterm_coverage_list
  #return (minterms_not_fully_covered.length == 0)
  end

  def generate_pi_combinations(ess_pi_list, non_ess_pi_list)
    # pi_list = ess_pi_list + non_ess_pi_list
    # we will calculate all possible combinations on non-essential PIs and will add ess. PIs to them
    pi_list = non_ess_pi_list
    puts "Number of non-essential PIs: #{pi_list.length}"
    pi_combinations = []
    
    pi_combinations.push(ess_pi_list)  # only the essential PIs list a possible combination    
    
    # Adding non-essentials PIs with the essential PI list to generate other possible combination of covers
    (1..pi_list.length).each do |i|
      pi_list.combination(i).to_a.each { |a| pi_combinations << a + ess_pi_list }
    end

    puts "Number of potential covers: #{pi_combinations.length}"
    pi_combinations
  end

  def is_PI_Essential(pi, working_pi_list)
    is_essential = false
    working_pi_list_index = 0
    is_essential = chain_sharp(pi, working_pi_list_index, working_pi_list)
    return is_essential
  end

  def chain_sharp(result, current_index, working_pi_list )
    is_essential = false
    new_result = []
    # sharp = SharpOperation.new
    
    if (current_index >= working_pi_list.length)

      # iteration done
      return ( result != 'NULL')
    else

      if( result == 'NULL')
      return false;
      else
        new_result = SharpOperation.sharp_operation(result, working_pi_list[current_index])
        (0...new_result.length).each do |i|
          if new_result[i] != 'NULL'
            is_essential = is_essential || chain_sharp(new_result[i], current_index + 1, working_pi_list)
          end
        end
      return is_essential
      end
    end
  end

  def find_all_covers(initial_cover, essential_pi_list, non_essential_pi_list)
    current_cover = essential_pi_list.clone
    working_set = non_essential_pi_list.clone
    @cover_list.clear

    check_coverage_combinations(initial_cover, essential_pi_list, non_essential_pi_list)
    #check_coverage_recursion(initial_cover, current_cover, working_set)

    return @cover_list
  end

  def check_coverage_combinations(minterms, essential_pi_list, non_essential_pi_list)
    possible_covers = generate_pi_combinations(essential_pi_list, non_essential_pi_list)
    (0...possible_covers.length).each do |i|
    #current_cover = essential_pi_list + possible_covers[i]
      current_cover = possible_covers[i]
      if does_pi_list_fully_cover_function(minterms, current_cover)
      @cover_list.push(possible_covers[i])
      end
    end
  end

  def check_coverage_recursion(minterms, current_cover, working_set)
    #current_cover = [p1, p2]
    #working_set = [p3, p4, p5]
    if (working_set.length == 0)
      # all the minterms have been added to cover

      unless(@all_minterms_added_to_cover)
        @cover_list.push(current_cover)
        @all_minterms_added_to_cover = true
      end

    return
    else
      if does_pi_list_fully_cover_function(minterms, current_cover)
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
    puts "\nFinding Minimum Cost Cover . . . ".colorize(:green)
    new_covers = cover_list # with the combination approach, we won't get duplicate covers
    #new_covers = remove_duplicates(cover_list)
    # Finding covers costs and minimum cost cover
    cover_value_hash = Hash.new{|h, k| h[k] = []}
    new_covers.each do |cover|
      cover_cost = starter_kit.function_cost(cover)
      puts "cost of cover #{cover}: #{cover_cost}".colorize(:light_blue)
      cover_value_hash[cover_cost] << cover
    end
    puts
    # puts "cover_value_hash: #{cover_value_hash.inspect}"
    minimum_cost_cover =  cover_value_hash.sort_by {|key, value| key}
    puts "Number of minimum cost covers: #{minimum_cost_cover[0][1].length}"
    puts "minimum_cost_cover: #{minimum_cost_cover[0][1]}".colorize(:light_blue)
    puts "cost of minimum_cost_cover: #{minimum_cost_cover[0][0]}".blue
    puts
    minimum_cost_cover
  end
end
