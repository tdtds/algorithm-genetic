
module Algorithm::Genetic::Selection
	module Elite
		def select(members, num)
			(block_given? ? members.sort{|a, b| yield a, b } : members.sort)[0, num]
		end
	end
end
