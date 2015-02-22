require './algo'

algo = Algo.new
# read file from command line
print 'Enter a digit for file name (type 1 for node_1, 2 for node_2 etc.): '
file_number = gets.chomp
file_name = "node#{file_number}.eblif"
starter_kit = StarterKit.new(file_name)
# read eblif file and set the instance variables after parsing the eblif file
starter_kit.read_eblif
pi = PrimeImplicant.new
# prime_implicants = pi.generate_prime_implicants(starter_kit.cubes)
# puts "prime_implicants: #{prime_implicants}"
# puts "- - - - - - - - - "
# puts 'Testing the example from the book . . . '
# cubes = ['0x000', '11010', '00001', '011x1', '101x1', '1x111', 'x0100', '11x00', '01010', '00101']
# prime_implicants = pi.generate_prime_implicants(cubes)
# puts "prime_implicants: #{prime_implicants.uniq}"
# cover for partial coverage
# initial_cover = ['0x0', '011', '010', 'x11', '1x1']
# initial_cover = cubes
# initial_cover = starter_kit.on_set
initial_cover = starter_kit.on_set
# pi_list = pi.generate_prime_implicants(initial_cover) #dc set should be regarded properly
pi_list = pi.generate_final_prime_implicants(starter_kit.on_set, starter_kit.dc_set) #dc set should be regarded properly
# pi_list = pi.generate_prime_implicants(['000x', 'x111','1x0x'])
# pi_list = pi.generate_final_prime_implicants(['000x', 'x111'], ['1x0x']) #dc set should be regarded properly
# puts "final_pi_list: #{pi_list.inspect}"

puts "Initial Cover: #{initial_cover.inspect}".colorize(:green)
puts "Prime Implicants: #{pi_list.inspect}".colorize(:blue)

categorized_pi_list =  algo.calculate_essential_pi_list(pi_list)
essential_pi_list = categorized_pi_list[0]
non_essential_pi_list = categorized_pi_list[1]

puts "essential_pi_list: #{essential_pi_list}".colorize(:blue)
puts "non-essential_pi_list: #{non_essential_pi_list}".colorize(:blue)

puts "checking if the essential prime implicants fully cover the function"
minterm_coverage_list = algo.get_minterm_function_coverage(initial_cover, essential_pi_list)

minterms_fully_covered = minterm_coverage_list[0]
minterms_not_fully_covered = minterm_coverage_list[1]

puts "minterms fully covered: #{minterms_fully_covered.inspect}".colorize(:green)
puts "minterms not fully covered: #{minterms_not_fully_covered.inspect}".colorize(:green)

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
# algo.generate_pi_combinations(essential_pi_list, non_essential_pi_list).inspect
