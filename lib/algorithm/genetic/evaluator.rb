
module Algorithm
	module Genetic
		#
		# = evaluate fitness of a gene
		#
		class Evaluator
			# evaluate fitness, implement by yourself
			#
			# gene :: a instance of Gene class
			def fitness(gene)
				raise NotImplementedError.new("implement 'fitness' method by yourself.")
			end

			# judgment of completion
			#
			# gene :: a instance of Gene class
			def finish?(gene)
				raise NotImplementedError.new("implement 'finish?' method by yourself.")
			end
		end
	end
end

