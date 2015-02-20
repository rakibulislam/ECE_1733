require './prime_implicant'
require './sharp_operation'
require './star_operation'
require 'pry'
require './starter_kit'

class Algo
  attr_accessor :pi_list, :essential_pi_list, :non_essential_pi_list, :initial_cover, :cover_list

  def initialize
    @pi_list = []
    @essential_pi_list = []
    @non_essential_pi_list = []
    @working_pi_list = []    
    @initial_cover = []
    @all_minterms_added_to_cover = false
    @cover_list = []
  end
  
  def calculate_essential_pi_list    
    
    # debug info; should be removed from final version
    puts 'calculating essential PIs:'   
    
    (0...@pi_list.length).each do |i|  
      @working_pi_list = @pi_list.clone
      
      @working_pi_list.delete_at(i)
      
      if is_PI_Essential( @pi_list[i])
        @essential_pi_list.push( @pi_list[i])
      else
        @non_essential_pi_list.push( @pi_list[i])
      end
    end
  end 
  
  def does_pi_list_fully_cover_function(minterms, current_cover)
    
    minterms_fully_covered = []
    minterms_not_fully_covered = []
	
	@working_pi_list = current_cover.clone
    
     (0...minterms.length).each do |i|
      if is_PI_Essential( minterms[i])
        minterms_not_fully_covered.push( minterms[i])
      else
        minterms_fully_covered.push( minterms[i])
      end
     end

    return (minterms_not_fully_covered.length == 0)     

  end
  
  # this function should be merged with the function "does_pi_list_fully_cover_function"
  def does_essential_pi_list_fully_cover_f(initial_minterms)
    puts "checking if the essential prime implicants fully cover the function"
    
    minterms_fully_covered = []
    minterms_not_fully_covered = []
    
    @working_pi_list = @essential_pi_list.clone
    
    (0...initial_minterms.length).each do |i|
      if is_PI_Essential( initial_minterms[i])
        minterms_not_fully_covered.push( initial_minterms[i])
      else
        minterms_fully_covered.push( initial_minterms[i])
      end
     end
     
    puts "minterms fully covered:" 
    puts "#{minterms_fully_covered.inspect}" 
    puts "minterms not fully covered:" 
    puts "#{minterms_not_fully_covered.inspect}" 
    
    return (minterms_not_fully_covered.length == 0)
    
  end
  
  def is_PI_Essential(pi)
    
    temp_result = []
    #temp_result.push(pi)
       
    is_essential = false    
    working_pi_list_index = 0       
    sharp = SharpOperation.new   
      
        # doing the first sharp operation
        
        temp_result = sharp.sharp_operation(pi, @working_pi_list[working_pi_list_index]);
  
        (0...temp_result.length).each do |j|        
          is_essential = is_essential || sharp_essential(temp_result[j] ,working_pi_list_index + 1)
        end
        
        return is_essential 
  end
  
  def sharp_essential(result, current_index)

    is_essential = false
    new_result = []
    sharp = SharpOperation.new  
    
    if (current_index >= @working_pi_list.length)    
      
      # iteration done      
      return ( result != 'NULL')        
    else
    
      if( result == 'NULL')
        return false;
      else
        new_result = sharp.sharp_operation(result, @working_pi_list[current_index])
        
        (0...new_result.length).each do |i|        
          if new_result[i] != 'NULL'
            
            is_essential = is_essential || sharp_essential(new_result[i], current_index + 1 )
            
          end
        end
        
        return is_essential
        
      end    
    end
 end

  def find_all_covers
    current_cover = essential_pi_list.clone
    working_set = non_essential_pi_list.clone
  
    #(0...non_essential_pi_list.length).each do |i|
    #while working_set.length > 0
    # current_cover = essential_pi_list.clone
    # current_cover.push(working_set.delete_at(i))
      
    # check_coverage_recursion(minterms, current_cover, working_set)
  
    check_coverage_recursion(initial_cover, current_cover, working_set)
    
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

  algo = Algo.new
  # algo.generate_pi_list  

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
  puts "- - - - - - - - - - - - - - - -"
  starter_kit = StarterKit.new(file_name)
  puts 'Finding Minimum Cost Cover . . .'
  puts
  # Finding covers costs and minimum cost cover
  covers = [['0x000', '11010', '00001'], ['101x1', '1x111', 'x0100'], ['11x00', '01010', '00101'], ['11010', '0x000', '00001'], ['00001', '11010', '0x000']] # will get this from Shah's algorithm
  puts "array of covers (before removing duplicate covers): #{covers.inspect}"
  new_covers = []
  covers.each { |cover| new_covers << cover.sort }
  new_covers = new_covers.uniq # removing duplicate covers
  puts "new array of covers (after removing duplicate covers): #{new_covers.inspect}"
  puts
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
  algo.pi_list =  ['xx00', '110x', '1x11', '10x0', '11x1','101x']
  
  
  # cover for partial coverage
  algo.initial_cover = ['0x0', '011', '010', 'x11', '1x1']
  #algo.initial_cover = ['xx00', '110x', '1x11', '10x0']
  # cover for full coverage
  # algo.initial_cover = ['0x0', '011', '010', '001', 'x11', '1x1']
  
  #algo.pi_list =  ['xx00', '110x', '1x11', '10x0', '11x1','101x']
  
  # not full coverage pi list
  algo.pi_list = ['0x0', '01x', 'x11', '1x1']
  #algo.pi_list = ['xx00', '110x', '1x11', '10x0', '11x1', '101x']
  # full coverage pi list
  #algo.pi_list = ['0xx', 'xx1']
  algo.calculate_essential_pi_list

  puts "This is essential PI list:"
  puts "#{algo.essential_pi_list.inspect}"
  puts "This is non-essential PI list:"
  puts "#{algo.non_essential_pi_list.inspect}"

  # cover for partial coverage
  # initial_cover = ['0x0', '011', '010', 'x11', '1x1']
  # cover for full coverage
  initial_cover = ['0x0', '011', '010', '001', 'x11', '1x1']
  
  
  if (algo.does_essential_pi_list_fully_cover_f(algo.initial_cover))
    puts "Essential PIs fully cover the function"
  else
    puts "Essential PIs don't fully cover the function. Need to include non-essential PIs for full cover"
  end 
  
  algo.find_all_covers
  
  puts "cover list length: #{algo.cover_list.length}"
  puts "This is the cover list:"
  
  (0...algo.cover_list.length).each do |k|
    puts "#{algo.cover_list[k].inspect}"
  end
end
