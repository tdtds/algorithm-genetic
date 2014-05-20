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
			# evaluator :: a Evaluator instance or a Proc instance returns Evaluator instance
			def initialize(code, evaluator, opts = {})
				@code, @evaluator_org, @opts = code, evaluator, opts
				if @evaluator_org.respond_to?(:fitness) # Evaluator instance
					@evaluator = @evaluator_org
				else # Proc instance
					@evaluator = @evaluator_org.call
				end

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
				return Gene.new(code1, @evaluator_org, @opts), Gene.new(code2, @evaluator_org, @opts)
			end

			# mutate the code
			#
			# chance :: probability of mutation (0.0 - 1.0)
			def mutate!(chance)
				return if rand > chance
				@code = mutate(@code)
				@fitness = @evaluator.fitness(self)
			end

			# judgement termination
			def terminated?
				@evaluator.terminated?(self)
			end
		end
	end
end

