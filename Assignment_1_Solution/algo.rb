require "./prime_implicant"

class Algo
  attr_accessor :pi_list

  def initialize
    @pi_list = []
  end

  def generate_pi_list
    # write your algo to generate pi_list....
    puts 'generating prime implicants....'
  end
  
  def calculate_essential_pi_list
    puts 'calculating essential PIs'
  end 
  
  
end

  algo = Algo.new
  algo.generate_pi_list
  algo.calculate_essential_pi_list
  
  pi = PrimeImplicant.new
  
  pi.value= '10x0'
  pi.isEssentialPI= true
  
  puts "Value of PI: #{pi.value}"
  puts "Is PI Essential: #{pi.isEssentialPI}"
  
  
  
  
  
