module Algorithm
	module Genetic
		#
		# = finish information
		#
		class FinishInformation < StandardError
			attr_reader :gene

			def initialize(gene)
				@gene = gene
				super('finished')
			end
		end

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
				@generation = 0
			end

			# increment the generation: senection, crossover and mutation
			def generate
				@generation += 1
				select(@members.length - 2)
				crossover
				mutate
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

			def select(num)
				sort!
				@members = @members[0, num]
			end

			def crossover
				@members += @members[0].crossover(@members[1])
			end

			def mutate
				@members.each do |m|
					m.mutate!(0.5)
					if @evaluator.finish?(m)
						sort!
						raise FinishInformation.new(m)
					end
				end
			end
		end
	end
end

