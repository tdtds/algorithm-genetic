#!/usr/bin/env ruby
#
# Algorithm::Genetic sample: say 'I Love Ruby'
#
require 'algorithm/genetic'

class StringEvaluator < Algorithm::Genetic::Evaluator
	def initialize(goal)
		@goal = goal
	end

	def fitness(gene)
		total = 0
		gene.code.each_byte.with_index do |c, i|
			total += (c.ord - @goal[i].ord) ** 2
		end
		return total
	end
end

class Population
	def initialize(goal, size)
		@goal = goal
		evaluator = StringEvaluator.new(goal)
		@members = Array.new(size){ Algorithm::Genetic::Gene.random(evaluator, @goal.length) }
		sort!
		@generation = 0
	end

	def sort!
		@members.sort! do |a, b|
			a.fitness <=> b.fitness
		end
	end

	def show
		puts "Generation: #{@generation}"
		@members.each do |m|
			puts "  #{m.code.inspect} (#{m.fitness})"
		end
		puts
	end

	def generate
		@generation += 1
		children = @members[0].cross(@members[1])
		@members = @members[0, @members.length - 2] + children
		@members.each do |m|
			m.mutate!(0.5)
			if m.code == @goal
				sort!
				show
				raise StandardError.new(@generation.to_s)
			end
		end
		sort!
	end
end

popuration = Population.new('I love Ruby', 10)
popuration.show
begin
	loop do
		popuration.generate
		popuration.show
	end
rescue StandardError
end
