#
# Crossover::Point: (one) point crossover
#
module Algorithm::Genetic::Crossover
	module Point
		def crossover(parent1, parent2, cut_num)
			pivot = (parent1.code.length / 2.0).round
			child1 = parent1.code[0, pivot] + parent2.code[pivot, pivot]
			child2 = parent2.code[0, pivot] + parent1.code[pivot, pivot]
			return child1, child2
		end
	end
end
