#
# Crossover::Order: order crossover
#
module Algorithm::Genetic::Crossover
	module Order
		def crossover(parent1, parent2)
			cut_point = rand(parent1.code.length)
			child1 = mate(parent1.code, parent2.code, cut_point)
			child2 = mate(parent2.code, parent1.code, cut_point)
			return child1, child2
		end

	private
		def mate(p1, p2, point)
			child = p1[0, point]
			p2.each do |g|
				child << g unless child.index(g)
			end
			return child
		end
	end
end
