require "./prime_implicant"
require "./sharp_operation"
require "./star_operation"
require "pry"

class Algo2
  attr_accessor :pi_list, :essential_pi_list, :non_essential_pi_list

  def initialize
    @pi_list = []
    @essential_pi_list = []
    @non_essential_pi_list = []
    @working_pi_list = []
    
  end

  def generate_pi_list
    # write your algo to generate pi_list....
    puts 'generating prime implicants....'
  end
  
  def calculate_essential_pi_list
    # hard-coding pi list, for now
    @pi_list = Array['xx00', '110x', '1x11', '10x0', '11x1','101x']
    
    # @pi_list = Array['0x0', '01x', 'x11', '1x1']
    
    # debug info; should be removed from final version
    puts ""
    puts 'calculating essential PIs:'   
    
    for i in 0...@pi_list.length   
      @working_pi_list = @pi_list.clone
      
      @working_pi_list.delete_at(i)
      
      if is_PI_Essential( @pi_list[i])
        @essential_pi_list.push( @pi_list[i])
      else
        @non_essential_pi_list.push( @pi_list[i])
      end
    end      
    
  end 
  
  def is_PI_Essential(pi)
    
    temp_result = []
    #temp_result.push(pi)
       
    is_essential = false
    
    working_pi_list_index = 0
       
    sharp = SharpOperation.new    
    
    # for i in 0...@pi_list.length
      
        # doing the first sharp operation
        
        temp_result = sharp.sharp_operation(pi, @working_pi_list[working_pi_list_index]);
  
        for j in 0...temp_result.length
        
          is_essential = is_essential || sharp_essential(temp_result[j] ,working_pi_list_index + 1)
        end
        
        return is_essential           
      
  end
  
  def sharp_essential(result, current_index)

  is_essential = false;
  
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
      
      for i in  0...new_result.length
      
        if new_result[i] != 'NULL'
          
          is_essential = is_essential || sharp_essential(new_result[i], current_index + 1 )
          
        end
      end
      
      return is_essential
      
    end
  
  end
end
  
   
end

  algo = Algo2.new
  # algo.generate_pi_list
  algo.calculate_essential_pi_list
  
  puts "This is essential PI list:"
  puts "#{algo.essential_pi_list.inspect}"
  puts "This is non-essential PI list:"
  puts "#{algo.non_essential_pi_list.inspect}"
  
  
  
  
