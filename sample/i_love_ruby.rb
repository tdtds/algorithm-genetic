#!/usr/bin/env ruby
#
# Algorithm::Genetic sample: say 'I Love Ruby'
#
require 'algorithm/genetic'
require 'algorithm/genetic/selection/elite'
require 'algorithm/genetic/crossover/oder'
require 'algorithm/genetic/mutation/shift'

class StringEvaluator < Algorithm::Genetic::Evaluator
	def initialize(goal)
		@goal = goal
	end

	def fitness(gene)
		total = 0
		gene.code.each_with_index do |c, i|
			total += (c.ord - @goal[i].ord) ** 2
		end
		return total
	end

	def finish?(gene)
		gene.code.join == @goal.join
	end
end

def show(population)
	puts "Generation: #{population.generation}"
	population.each do |gene|
		puts "  #{gene.code.join.inspect} (#{gene.fitness})"
	end
	puts
end

goal = 'I love Ruby'.split(//)
size = 10
evaluator = StringEvaluator.new(goal)
population = Algorithm::Genetic::Population.new(
	size, evaluator,
	selection: :elite,
	crossover: :oder,
	mutation: :shift
) do
	(' ' * goal.length).each_byte.map{|c| (rand * 255).to_i.chr}
end
show(population)
begin
	loop do
		population.generate
		show(population)
	end
rescue Algorithm::Genetic::FinishInformation => e
	puts "Got '#{e.gene.code.join}' at generation #{population.generation}."
end
