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

	def finish?(gene)
		gene.code == @goal
	end
end

def show(population)
	puts "Generation: #{population.generation}"
	population.each do |gene|
		puts "  #{gene.code.inspect} (#{gene.fitness})"
	end
	puts
end

goal = 'I love Ruby'
size_of_population = 10
evaluator = StringEvaluator.new(goal)
population = Algorithm::Genetic::Population.new(goal.length, size_of_population, evaluator)
show(population)
begin
	loop do
		population.generate
		show(population)
	end
rescue StandardError
	show(population)
end
