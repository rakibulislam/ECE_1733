require './prime_implicant'
require './sharp_operation'
require './star_operation'
require 'pry'
require './starter_kit'

class Algo
  attr_accessor :essential_pi_list, :non_essential_pi_list, :cover_list

  def initialize
    @pi_list = []
    @essential_pi_list = []
    @non_essential_pi_list = []
    @working_pi_list = []
    @initial_cover = []
    @all_minterms_added_to_cover = false
    @cover_list = []
  end

  def calculate_essential_pi_list(current_pi_list)
      # debug info; should be removed from final version
      puts 'calculating essential PIs:'

     categorized_pi_list = []
     working_pi_list = []

      (0...current_pi_list.length).each do |i|
        working_pi_list = current_pi_list.clone

        working_pi_list.delete_at(i)

        if is_PI_Essential( current_pi_list[i], working_pi_list)
          @essential_pi_list.push( current_pi_list[i])
        else
          @non_essential_pi_list.push( current_pi_list[i])
        end
      end

    categorized_pi_list.push(@essential_pi_list)
    categorized_pi_list.push(@non_essential_pi_list)

    return categorized_pi_list
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
    
  def is_PI_Essential(pi, working_pi_list)
    is_essential = false
    working_pi_list_index = 0
    is_essential = chain_sharp(pi, working_pi_list_index, working_pi_list)
    return is_essential
  end

  def chain_sharp(result, current_index, working_pi_list )
    is_essential = false
    new_result = []
    sharp = SharpOperation.new

    if (current_index >= working_pi_list.length)

      # iteration done
      return ( result != 'NULL')
    else

      if( result == 'NULL')
        return false;
      else
        new_result = sharp.sharp_operation(result, working_pi_list[current_index])
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
    check_coverage_recursion(initial_cover, current_cover, working_set)
	  return @cover_list
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
        @cover_list = remove_duplicates(@cover_list)
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
    # cover_list = [['0x000', '11010', '00001'], ['101x1', '1x111', 'x0100'], ['11x00', '01010', '00101'], ['11010', '0x000', '00001'], ['00001', '11010', '0x000']] # will get this from Shah's algorithm
    puts "array of covers (before removing duplicate covers): #{cover_list.inspect}"
    puts "size of colver_list (before removing duplicates): #{cover_list.length}"
    new_covers = []
    cover_list.each { |cover| new_covers << cover.sort }
    new_covers = new_covers.uniq # removing duplicate covers
    puts "new array of covers (after removing duplicate covers): #{new_covers.inspect}"
    puts "size of colver_list (after removing duplicate covers): #{new_covers.length}"
    new_covers # returns the covers after removing duplicates
  end

  def find_minimum_cost_cover(cover_list, file_name)
    starter_kit = StarterKit.new(file_name)
    puts 'Finding Minimum Cost Cover . . .'
    new_covers = remove_duplicates(cover_list)
    # Finding covers costs and minimum cost cover
    cover_value_hash = Hash.new{|h, k| h[k] = []}
    new_covers.each do |cover|
      cover_cost = starter_kit.function_cost(cover)
      puts "cost of cover #{cover}: #{cover_cost}"
      cover_value_hash[cover_cost] << cover
    end
    puts
    # puts "cover_value_hash: #{cover_value_hash.inspect}"
    minimum_cost_cover =  cover_value_hash.sort_by {|key, value| key}
    puts "minimum_cost_cover: #{minimum_cost_cover[0][1]}"
    puts "cost of minimum_cost_cover: #{minimum_cost_cover[0][0]}"
    puts
    minimum_cost_cover
  end

  algo = Algo.new
  # read file from command line
  print 'Enter a digit for file name (type 1 for node_1, 2 for node_2 etc.): '
  file_number = gets.chomp
  file_name = "node#{file_number}.eblif"
  starter_kit = StarterKit.new(file_name)
  # read eblif file and set the instance variables after parsing the eblif file
  starter_kit.read_eblif
  pi = PrimeImplicant.new
  prime_implicants = pi.generate_prime_implicants(starter_kit.cubes)
  puts "prime_implicants: #{prime_implicants}"
  puts "- - - - - - - - - "
  puts 'Testing the example from the book . . . '
  cubes = ['0x000', '11010', '00001', '011x1', '101x1', '1x111', 'x0100', '11x00', '01010', '00101']
  prime_implicants = pi.generate_prime_implicants(cubes)
  puts "prime_implicants: #{prime_implicants.uniq}"
  # cover for partial coverage
  initial_cover = ['0x0', '011', '010', 'x11', '1x1']
  # initial_cover = cubes
  
  pi_list = pi.generate_prime_implicants(initial_cover) #dc set should be regarded properly
  
  puts "Initial Cover :"
  puts "#{initial_cover.inspect}"
  puts "Prime Implicant List:"
  puts "#{pi_list.inspect}"
  
  categorized_pi_list =  algo.calculate_essential_pi_list(pi_list)
  essential_pi_list = categorized_pi_list[0]
  non_essential_pi_list = categorized_pi_list[1]

  puts "This is the essential PI list:"
  puts "#{categorized_pi_list[0].inspect}"
  puts "This is the non-essential PI list:"
  puts "#{categorized_pi_list[1].inspect}"

  puts "checking if the essential prime implicants fully cover the function"  
  minterm_coverage_list = algo.get_minterm_function_coverage(initial_cover, essential_pi_list)
  
  minterms_fully_covered = minterm_coverage_list[0]
  minterms_not_fully_covered = minterm_coverage_list[1]
     
  puts "minterms fully covered:" 
  puts "#{minterms_fully_covered.inspect}" 
  puts "minterms not fully covered:" 
  puts "#{minterms_not_fully_covered.inspect}"    
  
  if (minterms_not_fully_covered.length == 0)  #all the minterms in the initial cover are covered by the essential PIs
    puts "Essential PIs fully cover the function"
  else
    puts "Essential PIs don't fully cover the function. Need to include non-essential PIs for full cover"
  end 

  cover_list = algo.find_all_covers(initial_cover, essential_pi_list, non_essential_pi_list)

  puts "Number of covers (including all combinations): #{cover_list.length}"
  puts "This is the cover list:"
  
  (0...cover_list.length).each do |k|
    puts "#{cover_list[k].inspect}"
  end

  minimum_cost_cover = algo.find_minimum_cost_cover(cover_list, file_name)
end
