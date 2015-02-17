require "./prime_implicant"
require "./sharp_operation"
require "./star_operation"
require "pry"

class Algo
  attr_accessor :pi_list, :essential_pi_list, :non_essential_pi_list

  def initialize
    @pi_list = []
    @essential_pi_list = []
    @non_essential_pi_list = []
    
  end

  def generate_pi_list
    # write your algo to generate pi_list....
    puts 'generating prime implicants....'
  end
  
  def calculate_essential_pi_list
    # hard-coding pi list, for now
    @pi_list = Array['0x0', '01x', 'x11', '1x1']
    
    # debug info; should be removed from final version
    puts ""
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
  
end

  algo = Algo.new
  # algo.generate_pi_list
  algo.calculate_essential_pi_list
  
  puts "This is essential PI list:"
  puts "#{algo.essential_pi_list.inspect}"
  puts "This is non-essential PI list:"
  puts "#{algo.non_essential_pi_list.inspect}"
  
  

  
  
  
  
  
