module Algorithm
	module Genetic
		#
		# = A gene class
		#
		class Gene
			attr_reader :code, :fitness

			# constructor of Gene
			#
			# code :: initial code as Array
			# evaluator :: a instance of Evaluator
			def initialize(code, evaluator, opts = {})
				@code, @evaluator, @opts = code, evaluator, opts
				@fitness = @evaluator.fitness(self)
				if opts[:crossover]
					crossover_module = opts[:crossover].to_s.capitalize
					self.extend(Algorithm::Genetic::Crossover.const_get(crossover_module))
				end
				if opts[:mutation]
					mutation_module = opts[:mutation].to_s.capitalize
					self.extend(Algorithm::Genetic::Mutation.const_get(mutation_module))
				end
			end

			# crossover with a partner, returning a couple of children
			#
			# partner :: a partner's gene
			def crossover_with(partner)
				code1, code2 = crossover(self, partner)
				return Gene.new(code1, @evaluator, @opts), Gene.new(code2, @evaluator, @opts)
			end

			# mutate the code
			#
			# chance :: probability of mutation (0.0 - 1.0)
			def mutate!(chance)
				return if rand > chance
				@code = mutate(@code)
				@fitness = @evaluator.fitness(self)
			end
		end
	end
end

