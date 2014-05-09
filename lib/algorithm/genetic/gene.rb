module Algorithm
	module Genetic
		#
		# = A gene class
		#
		class Gene
			attr_reader :code, :fitness

			# generate random gene, returning a new gene instance
			#
			# length :: length of the gene
			def self.random(length)
				
			end

			# constructor of Gene
			#
			# code :: initial code as Array
			# evaluator :: a instance of Evaluator
			def initialize(code, evaluator)
				@code = code
				@fitness = @evaluator.fitness(self)
			end

			# cross with a partner, returning a couple of children
			#
			# partner :: a partner's gene
			def cross(partner)

			end

			# mutate the code
			#
			# chance :: probability of mutation (0.0 - 1.0)
			def mutate(chance)

			end
		end
	end
end

