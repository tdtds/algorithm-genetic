
module Algorithm::Genetic::Mutation
	module Shift
		def mutate(code)
			index = (rand * code.length).to_i
			direction = rand <= 0.5 ? -1 : 1
			begin
				new_char = (code[index].ord + direction).chr
			rescue
				return(code)
			end
			code[index] = new_char
			return code
		end
	end
end
