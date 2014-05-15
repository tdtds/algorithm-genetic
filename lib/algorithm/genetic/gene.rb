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
			def self.random(evaluator, length)
				self.new((' ' * length).each_byte.map{|c| (rand * 255).to_i.chr}.join, evaluator)
			end

			# constructor of Gene
			#
			# code :: initial code as Array
			# evaluator :: a instance of Evaluator
			def initialize(code, evaluator)
				@code, @evaluator = code, evaluator
				@fitness = @evaluator.fitness(self)
			end

			# crossover with a partner, returning a couple of children
			#
			# partner :: a partner's gene
			def crossover(partner)
				pivot = (code.length / 2.0).round
				child1 = code[0, pivot] + partner.code[pivot, pivot]
				child2 = partner.code[0, pivot] + code[pivot, pivot]
				return Gene.new(child1, @evaluator), Gene.new(child2, @evaluator)
			end

			# mutate the code
			#
			# chance :: probability of mutation (0.0 - 1.0)
			def mutate!(chance)
				return if rand > chance

				index = (rand * code.length).to_i
				direction = rand <= 0.5 ? -1 : 1
				new_char = (code[index].ord + direction).chr rescue return
				code[index] = new_char
				@fitness = @evaluator.fitness(self)
			end
		end
	end
end

