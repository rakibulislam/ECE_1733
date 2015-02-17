class StarterKit
  attr_accessor :on_set, :dc_set, :number_of_inputs, :number_of_cubes, :cubes

  def initialize()
    @on_set = Array.new
    @dc_set = Array.new
    @cubes = Array.new
    @number_of_inputs = 0
    @number_of_cubes = 0
  end

  # read eblif file and parse it to build the cubes, ON_SET and DC_SET
  def read_eblif(fileName = 'node2.eblif')
    puts "Opening file #{fileName}"
    
    f = File.open(fileName)
    f.each do |line|
      if line.start_with? '.names'
        @number_of_inputs = line.split(' ').size - 2
        next
      end
      # puts line.inspect
      cube = line.split(' ')[0]
      output = line.split(' ')[1]
            
      # puts "cube: #{cube}"
      # puts "cube_cost: #{cube_cost(cube)}"

      if output == '1'
        on_set << cube
      elsif output == 'd' || output == 'x'
        dc_set << cube
      end
    end
    # a function is a set of cubes
    @cubes = on_set + dc_set
    @number_of_cubes = cubes.size
  end

  def cube_cost(cube)
    cost = 0
    (0...cube.length).each do |index|
      cost += 1 unless cube[index] == 'x' || cube[index] == 'd'
    end
    cost += 1 if cost > 1
  end

  # cover_cost will be same as function_cost as it takes a set of cubes and returns the toal cost of cubes
  def function_cost(cubes)
    cost = 0
    (0...cubes.length).each do |index|
      cost += cube_cost(cubes[index])
    end
    # function.length = num_of_cubes in the function
    cost += cubes.length + 1 if cubes.length > 1
  end
end

# Command line Args are put here for now
# Will be changed later i.e maybe move to a Main.rb file?
# if ARGV.length == 1
#   starterKit = StarterKit.new
#   starterKit.read_eblif(ARGV[0])
# else
#   puts "Please enter the eblif filename in the command line when you start the application"
# end
