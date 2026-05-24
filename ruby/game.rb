#!/usr/bin/env ruby

# Python Game - Ruby Implementation

class Player
  attr_accessor :name, :x, :y, :health, :score, :level

  def initialize(name)
    @name = name
    @x = 0
    @y = 0
    @health = 100
    @score = 0
    @level = 1
  end

  def move(dx, dy)
    @x += dx
    @y += dy
  end

  def take_damage(amount)
    @health = [@health - amount, 0].max
    @health > 0
  end

  def add_score(points)
    @score += points
  end

  def heal
    if @health < 100
      heal_amount = [20, 100 - @health].min
      @health += heal_amount
      puts "Healed for #{heal_amount} HP"
    else
      puts "Already at full health!"
    end
  end

  def display_status
    puts "\n[#{@name}] HP: #{@health} | Score: #{@score} | Level: #{@level}"
  end
end

class GameEngine
  def initialize
    @player = nil
    @running = true
  end

  def run
    puts "\n=== Ruby Game Engine ==="
    puts "Welcome to the Ruby Game!\n"

    print "Enter your player name: "
    name = gets.chomp
    name = "Hero" if name.empty?

    @player = Player.new(name)

    while @running && @player.health > 0
      @player.display_status
      handle_input
      update_game
    end

    end_game
  end

  def handle_input
    print "Commands: (m)ove, (a)ttack, (h)eal, (q)uit: "
    command = gets.chomp.downcase[0]

    case command
    when 'm'
      dx = rand(-2..2)
      dy = rand(-2..2)
      @player.move(dx, dy)
      puts "Moved to (#{@player.x}, #{@player.y})"
    when 'a'
      attack
    when 'h'
      @player.heal
    when 'q'
      @running = false
    else
      puts "Unknown command"
    end
  end

  def attack
    damage = rand(10..30)
    puts "You attacked for #{damage} damage!"
    @player.add_score(damage)
  end

  def update_game
    if rand < 0.1
      damage = rand(5..15)
      puts "\nEnemy attacked for #{damage} damage!"
      @player.take_damage(damage)
    end
  end

  def end_game
    puts "\n=== GAME OVER ==="
    puts "Final Score: #{@player.score}"
  end
end

if __FILE__ == $0
  engine = GameEngine.new
  engine.run
end
