#!/usr/bin/env python3
"""
Python Game - Main Game Logic
"""

import sys
import random
from enum import Enum

class GameState(Enum):
    MENU = 1
    PLAYING = 2
    PAUSED = 3
    GAME_OVER = 4

class Player:
    def __init__(self, name, x=0, y=0):
        self.name = name
        self.x = x
        self.y = y
        self.health = 100
        self.score = 0
        self.level = 1
    
    def move(self, dx, dy):
        self.x += dx
        self.y += dy
    
    def take_damage(self, amount):
        self.health = max(0, self.health - amount)
        return self.health > 0
    
    def add_score(self, points):
        self.score += points
    
    def __repr__(self):
        return f"Player({self.name}, HP={self.health}, Score={self.score})"

class Game:
    def __init__(self):
        self.state = GameState.MENU
        self.player = None
        self.enemies = []
        self.running = True
    
    def start(self):
        """Initialize and start the game"""
        print("\n=== Python Game Engine ===")
        print("Welcome to the Python Game!\n")
        
        name = input("Enter your player name: ").strip() or "Hero"
        self.player = Player(name)
        self.state = GameState.PLAYING
        self.run_game_loop()
    
    def run_game_loop(self):
        """Main game loop"""
        while self.running and self.state == GameState.PLAYING:
            self.display_status()
            self.handle_input()
            self.update_game()
            self.check_win_condition()
    
    def display_status(self):
        """Display current game status"""
        print(f"\n[{self.player.name}] HP: {self.player.health} | Score: {self.player.score} | Level: {self.player.level}")
        print("Commands: (m)ove, (a)ttack, (h)eal, (q)uit")
    
    def handle_input(self):
        """Handle player input"""
        command = input("Action: ").strip().lower()
        
        if command == 'q':
            self.running = False
        elif command == 'm':
            dx = random.randint(-2, 2)
            dy = random.randint(-2, 2)
            self.player.move(dx, dy)
            print(f"Moved to ({self.player.x}, {self.player.y})")
        elif command == 'a':
            self.attack()
        elif command == 'h':
            self.heal()
    
    def attack(self):
        """Handle attack action"""
        damage = random.randint(10, 30)
        print(f"You attacked for {damage} damage!")
        self.player.add_score(damage)
    
    def heal(self):
        """Handle heal action"""
        if self.player.health < 100:
            heal_amount = min(20, 100 - self.player.health)
            self.player.health += heal_amount
            print(f"Healed for {heal_amount} HP")
        else:
            print("Already at full health!")
    
    def update_game(self):
        """Update game state"""
        if random.random() < 0.1:
            damage = random.randint(5, 15)
            print(f"\nEnemy attacked for {damage} damage!")
            self.player.take_damage(damage)
    
    def check_win_condition(self):
        """Check if game is won or lost"""
        if self.player.health <= 0:
            self.state = GameState.GAME_OVER
            print(f"\n=== GAME OVER ===")
            print(f"Final Score: {self.player.score}")
            self.running = False
        elif self.player.score >= 200:
            self.player.level += 1
            print(f"\n*** LEVEL UP: {self.player.level} ***")
            self.player.score = 0
            self.player.health = 100

def main():
    game = Game()
    game.start()

if __name__ == "__main__":
    main()
