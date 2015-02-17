require './star_operation'
class PrimeImplicant
  attr_accessor :value, :isEssentialPI
  
  def initialize
    @value = ''
    @isEssentialPI = false
  end

  def generate_prime_implicants(initial_cover)
    puts "given set of implicants: #{initial_cover.inspect}"
    start_operation_results = []
    star = StarOperation.new

    initial_cover.each_with_index do |cube, index|
      puts "index: #{index}"

    end
  end
end
