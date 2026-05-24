#!/usr/bin/env python3
"""
Snake Game - A simple pygame-based snake game for Linux
"""

import pygame
import random
import sys
from enum import Enum

class Direction(Enum):
    UP = (0, -1)
    DOWN = (0, 1)
    LEFT = (-1, 0)
    RIGHT = (1, 0)

class SnakeGame:
    def __init__(self, width=640, height=480, block_size=20):
        pygame.init()
        
        self.width = width
        self.height = height
        self.block_size = block_size
        self.grid_width = width // block_size
        self.grid_height = height // block_size
        
        self.screen = pygame.display.set_mode((width, height))
        pygame.display.set_caption("Python Snake Game")
        
        self.clock = pygame.time.Clock()
        self.font = pygame.font.Font(None, 36)
        self.small_font = pygame.font.Font(None, 24)
        
        self.reset_game()
    
    def reset_game(self):
        """Initialize/reset game state"""
        self.snake = [(self.grid_width // 2, self.grid_height // 2)]
        self.direction = Direction.RIGHT
        self.next_direction = Direction.RIGHT
        self.food = self.spawn_food()
        self.score = 0
        self.game_over = False
    
    def spawn_food(self):
        """Spawn food at random location"""
        while True:
            x = random.randint(0, self.grid_width - 1)
            y = random.randint(0, self.grid_height - 1)
            if (x, y) not in self.snake:
                return (x, y)
    
    def handle_input(self):
        """Handle keyboard input"""
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                return False
            
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_UP and self.direction != Direction.DOWN:
                    self.next_direction = Direction.UP
                elif event.key == pygame.K_DOWN and self.direction != Direction.UP:
                    self.next_direction = Direction.DOWN
                elif event.key == pygame.K_LEFT and self.direction != Direction.RIGHT:
                    self.next_direction = Direction.LEFT
                elif event.key == pygame.K_RIGHT and self.direction != Direction.LEFT:
                    self.next_direction = Direction.RIGHT
                elif event.key == pygame.K_r and self.game_over:
                    self.reset_game()
                    return True
                elif event.key == pygame.K_q:
                    return False
        
        return True
    
    def update(self):
        """Update game state"""
        if self.game_over:
            return
        
        self.direction = self.next_direction
        
        # Calculate new head position
        head_x, head_y = self.snake[0]
        dx, dy = self.direction.value
        new_head = (head_x + dx, new_head_y := head_y + dy)
        
        # Check wall collision
        if (new_head[0] < 0 or new_head[0] >= self.grid_width or
            new_head[1] < 0 or new_head[1] >= self.grid_height):
            self.game_over = True
            return
        
        # Check self collision
        if new_head in self.snake:
            self.game_over = True
            return
        
        # Add new head
        self.snake.insert(0, new_head)
        
        # Check food collision
        if new_head == self.food:
            self.score += 10
            self.food = self.spawn_food()
        else:
            # Remove tail if no food eaten
            self.snake.pop()
    
    def draw(self):
        """Render game"""
        self.screen.fill((0, 0, 0))
        
        # Draw snake
        for i, segment in enumerate(self.snake):
            x, y = segment
            rect = pygame.Rect(x * self.block_size, y * self.block_size,
                             self.block_size - 1, self.block_size - 1)
            color = (0, 255, 0) if i == 0 else (0, 200, 0)
            pygame.draw.rect(self.screen, color, rect)
        
        # Draw food
        food_x, food_y = self.food
        rect = pygame.Rect(food_x * self.block_size, food_y * self.block_size,
                          self.block_size - 1, self.block_size - 1)
        pygame.draw.rect(self.screen, (255, 0, 0), rect)
        
        # Draw score
        score_text = self.font.render(f"Score: {self.score}", True, (255, 255, 255))
        self.screen.blit(score_text, (10, 10))
        
        # Draw game over message
        if self.game_over:
            game_over_text = self.font.render("GAME OVER!", True, (255, 0, 0))
            restart_text = self.small_font.render("Press R to restart or Q to quit", True, (255, 255, 255))
            
            game_over_rect = game_over_text.get_rect(center=(self.width // 2, self.height // 2 - 30))
            restart_rect = restart_text.get_rect(center=(self.width // 2, self.height // 2 + 30))
            
            self.screen.blit(game_over_text, game_over_rect)
            self.screen.blit(restart_text, restart_rect)
        
        pygame.display.flip()
    
    def run(self):
        """Main game loop"""
        running = True
        
        while running:
            running = self.handle_input()
            self.update()
            self.draw()
            self.clock.tick(10)  # 10 FPS for snake movement
        
        pygame.quit()

def main():
    game = SnakeGame()
    game.run()

if __name__ == "__main__":
    main()
