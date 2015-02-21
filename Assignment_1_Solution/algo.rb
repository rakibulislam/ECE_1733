require './prime_implicant'
require './sharp_operation'
require './star_operation'
require 'pry'
require './starter_kit'

class Algo
  attr_accessor :pi_list, :essential_pi_list, :non_essential_pi_list

  def initialize
    @pi_list = []
    @essential_pi_list = []
    @non_essential_pi_list = []
  end
  
  def calculate_essential_pi_list
    # hard-coding pi list, for now
    @pi_list = Array['0x0', '01x', 'x11', '1x1']
    
    # debug info; should be removed from final version
    puts 'calculating essential PIs:'   
    
    for i in 0...@pi_list.length   
      if is_PI_Essential( @pi_list[i], i)
        @essential_pi_list.push( @pi_list[i])
      else
        @non_essential_pi_list.push( @pi_list[i])
      end
    end
  end 
  
  def is_PI_Essential(pi, index)
    temp_result = []
    temp_result.push(pi)
       
    sharp = SharpOperation.new
    
    for i in 0...@pi_list.length
      if i == index
        next  # the sharp operation shouldn't be performed with the prime implicant itself
      else
        if temp_result.length == 1
          temp_result = sharp.sharp_operation(temp_result[0], @pi_list[i])
        end
        
        if temp_result.length == 1 && temp_result[0] == 'NULL'
          return false # the PI is non-essential since the sharp operation has returned NULL
        end
        
      end
    end
    return true  # the PI is essential
  end

  algo = Algo.new
  # algo.generate_pi_list
  algo.calculate_essential_pi_list

  puts "This is essential PI list:"
  puts "#{algo.essential_pi_list.inspect}"
  puts "This is non-essential PI list:"
  puts "#{algo.non_essential_pi_list.inspect}"
  puts 'calculating essential PIs'

  algo = Algo.new
  algo.calculate_essential_pi_list

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
end
