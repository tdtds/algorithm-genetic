
module Algorithm::Genetic::Selection
	module Aliasmethod
		def select(members, num)
			(block_given? ? members.sort{|a, b| yield a, b } : members.sort)[0, num]
		end

		def self.aliasmethod(*argv)
			ns = argv
			num = ns.size
			sum = ns.inject{|i, sum| sum += i}
			p_k = ns.map{|i| i / sum}
			puts "p_{k}: #{p_k}"

			v_k = p_k.map{|i| num * i}

			g = []
			s = []
			num.times do |i|
				g << i if v_k[i] >= 1
				s << i if v_k[i] < 1
			end

			a_k = []
			while !g.empty? && !s.empty? do
				k = s.first
				l = g.first

				puts "v_{k}: #{v_k}"
				puts "S: #{s}"
				puts "G: #{g}"
				puts "k=#{k}, l=#{l}"
				puts

				a_k[k] = l
				v_k[l] = v_k[l] - (1 - v_k[k])

				s.shift

				s << g.shift if v_k[l] < 1
			end

			puts "k p_{k} Kp_{k} v_{k} a_{k}"
			num.times{|i| puts "#{i} #{p_k[i]} #{num * p_k[i]} #{v_k[i]} #{a_k[i] || '*'}"}
			puts

			def self.gen(a_r, v_r)
				v = rand * v_r.size
				k = v.to_i
				u = v - k
				if u <= v_r[k]
					return k
				else
					return a_r[k]
				end
			end

			n = 1000000
			count = Array.new(num, 0)
			n.times{|i| count[gen(a_k, v_k)] += 1}
			num.times{|i| puts "#{i} #{"*" * (count[i]/10000)} #{count[i]}"}
		end
	end
end

