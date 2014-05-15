module Algorithm
	module Genetic
		#
		# = population management class
		#
		class Population
			attr_reader :generation
		
			# constructor of population
			#
			# code_length :: size of code
			# population_size :: size of population
			# evaluator :: an instance of evaluator
			def initialize(code_length, population_size, evaluator)
				@evaluator = evaluator
				@members = Array.new(population_size){
					Algorithm::Genetic::Gene.random(evaluator, code_length)
				}
				sort!
				@generation = 0
			end

			# increment the generation: senection, crossover and mutation
			def generate
				@generation += 1
				children = @members[0].cross(@members[1])
				@members = @members[0, @members.length - 2] + children
				@members.each do |m|
					m.mutate!(0.5)
					if @evaluator.finish?(m)
						sort!
						raise StandardError.new(@generation.to_s)
					end
				end
				sort!
			end

			# iterate each member
			def each
				@members.each {|m| yield m }
			end
		
		private
			def sort!
				@members.sort! do |a, b|
					a.fitness <=> b.fitness
				end
			end
		end
	end
end

