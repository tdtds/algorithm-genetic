module Algorithm
	module Genetic
		#
		# = terminated exception
		#
		class Terminated < StandardError
			attr_reader :gene

			def initialize(gene)
				@gene = gene
				super('terminated.')
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
			# opts :: hash of options
			#
			# options:
			#   :selection :: module name including select method
			#   :crossover :: module name including crossover method
			#   :mutation  :: module name including mutate method
			#
			# need block for generate an initial (random) code of a gene
			def initialize(population_size, evaluator, opts = {})
				@evaluator = evaluator
				@members = Array.new(population_size){
					Algorithm::Genetic::Gene.new(yield, evaluator, opts)
				}
				@generation = 0
				if opts[:selection]
					selection_module = opts[:selection].to_s.capitalize
					self.extend(Algorithm::Genetic::Selection.const_get(selection_module))
				end
			end

			# increment the generation: senection, crossover and mutation
			def generate
				@generation += 1
				select!(@members.length - 2)
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

			def select!(num)
				@members = select(@members, num) do |a, b|
					a.fitness <=> b.fitness
				end
			end

			def crossover
				@members += @members[0].crossover_with(@members[1])
			end

			def mutate
				@members.each do |m|
					m.mutate!(0.5)
					if @evaluator.terminated?(m)
						sort!
						raise Terminated.new(m)
					end
				end
			end
		end
	end
end

