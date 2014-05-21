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
			# evaluator :: an Evaluator instance or Proc instance returns Evaluator instance
			# opts :: hash of options
			#
			# options:
			#   :selection :: an array of module name including select method and params
			#   :crossover :: an array of module name including crossover method and params
			#   :mutation  :: an array of module name including mutate method and params
			#   :mutation_chance :: mutation chance (float of 0 to 1)
			#
			# need block for generate an initial (random) code of a gene
			def initialize(population_size, evaluator, opts = {})
				@evaluator = evaluator
				@members = Array.new(population_size){
					Algorithm::Genetic::Gene.new(yield, evaluator, opts)
				}
				@generation = 0

				if opts[:selection]
					@selection_params = opts[:selection].dup
					selection_module = @selection_params.shift.to_s.capitalize
					self.extend(Algorithm::Genetic::Selection.const_get(selection_module))
				end
			end

			# increment the generation: senection, crossover and mutation
			def generate
				@generation += 1
				select!
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
					b.fitness <=> a.fitness
				end
			end

			def select!
				@members = select(@members, *@selection_params) do |a, b|
					b.fitness <=> a.fitness
				end
			end

			def crossover
				@members += @members[0].crossover_with(@members[1])
			end

			def mutate
				@members.each do |m|
					m.mutate!
					if m.terminated?
						sort!
						raise Terminated.new(m)
					end
				end
			end
		end
	end
end

