
module Algorithm::Genetic::Mutation
	module Swap
		def mutate(code)
			i1, i2 = (rand * code.length).to_i, (rand * code.length).to_i
			code[i1], code[i2] = code[i2], code[i1]
			return code
		end
	end
end

