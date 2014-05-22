#!/usr/bin/env ruby
#
# Algorithm::Genetic sample: traveling salesman problem
#
require 'algorithm/genetic'
require 'algorithm/genetic/selection/elite'
require 'algorithm/genetic/crossover/order'
require 'algorithm/genetic/mutation/swap'

class City
	attr_reader :name, :x, :y

	def initialize(name, x, y)
		@name, @x, @y = name, x, y
	end

	def distance_with(city)
		Math.sqrt((@x - city.x) ** 2 + (@y - city.y) ** 2)
	end
end

class RouteEvaluator < Algorithm::Genetic::Evaluator
	def initialize(start)
		@start = start
	end

	def fitness(gene)
		total = 0.0
		prev = @start
		gene.code.each do |city|
			total += prev.distance_with(city)
			prev = city
		end
		total += prev.distance_with(@start)
		return -total
	end

	def terminated?(gene)
		# cannot know termination by gene.
		# stop yourself by limitation of generation count
		return false
	end
end

def distance_char(city1, city2)
	'_' * (city1.distance_with(city2) / 20)
end

def show(population, start)
	puts "Generation: #{population.generation}"
	population.each do |cities|
		printf('%7.2f %s', -cities.fitness, start.name)
		prev = start
		cities.code.map do |city|
			print distance_char(prev, city)
			print city.name
			prev = city
		end
		print distance_char(prev, start)
		puts start.name
	end
	puts
end

#
# create all cities
#
name = '@' # previous of 'A'
cities = Array.new(20).map do
	City.new(name.succ!.dup, 0.0 + rand(100), 0.0 + rand(100))
end
start = cities.shift

size = 10
evaluator = RouteEvaluator.new(start)
population = Algorithm::Genetic::Population.new(
	size, evaluator,
	selection: [:elite, size - 2],
	crossover: [:order],
	mutation: [:swap],
	mutation_chance: 0.3
) do
	cities.shuffle
end

show(population, start)
print "press any key to start."
gets
1000.times do
	population.generate
	show(population, start)
end
printf('distance: %1.2f ', -population.first.fitness)
puts("#{start.name}-#{population.first.code.map{|city| city.name}.join('-')}-#{start.name}")
