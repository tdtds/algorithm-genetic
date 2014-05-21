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
			# opts :: hash of options
			#
			# options:
			#   :crossover :: an array of module name including crossover method and params
			#   :mutation  :: an array of module name including mutate method and params
			#   :mutation_chance :: mutation chance (float of 0 to 1)
			def initialize(code, evaluator, opts = {})
				@code, @evaluator_org, @opts = code, evaluator, opts
				if @evaluator_org.respond_to?(:fitness) # Evaluator instance
					@evaluator = @evaluator_org
				else # Proc instance
					@evaluator = @evaluator_org.call
				end
				@fitness = @evaluator.fitness(self)

				if opts[:crossover]
					@crossover_params = opts[:crossover].dup
					crossover_module = @crossover_params.shift.to_s.capitalize
					self.extend(Algorithm::Genetic::Crossover.const_get(crossover_module))
				end
				if opts[:mutation]
					@mutation_params = opts[:mutation].dup
					mutation_module = @mutation_params.shift.to_s.capitalize
					self.extend(Algorithm::Genetic::Mutation.const_get(mutation_module))
				end
				@mutation_chance = opts[:mutation_chance] || 0.5
			end

			# crossover with a partner, returning a couple of children
			#
			# partner :: a partner's gene
			def crossover_with(partner)
				code1, code2 = crossover(self, partner, *@crossover_params)
				return Gene.new(code1, @evaluator_org, @opts), Gene.new(code2, @evaluator_org, @opts)
			end

			# mutate the code
			def mutate!
				return if rand > @mutation_chance
				@code = mutate(@code, *@mutation_params)
				@fitness = @evaluator.fitness(self)
			end

			# judgement termination
			def terminated?
				@evaluator.terminated?(self)
			end
		end
	end
end

