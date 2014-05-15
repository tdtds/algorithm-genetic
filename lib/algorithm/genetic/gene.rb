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
				if opts[:mutation]
					mutation_module = opts[:mutation].to_s.capitalize
					self.extend(Algorithm::Genetic::Mutation.const_get(mutation_module))
				end
			end

			# crossover with a partner, returning a couple of children
			#
			# partner :: a partner's gene
			def crossover(partner)
				pivot = (code.length / 2.0).round
				child1 = code[0, pivot] + partner.code[pivot, pivot]
				child2 = partner.code[0, pivot] + code[pivot, pivot]
				return Gene.new(child1, @evaluator, @opts), Gene.new(child2, @evaluator, @opts)
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

