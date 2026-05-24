use rand::Rng;
use std::io::{self, Write};

#[derive(Debug)]
struct Player {
    name: String,
    x: i32,
    y: i32,
    health: i32,
    score: i32,
    level: i32,
}

impl Player {
    fn new(name: String) -> Self {
        Player {
            name,
            x: 0,
            y: 0,
            health: 100,
            score: 0,
            level: 1,
        }
    }

    fn move_player(&mut self, dx: i32, dy: i32) {
        self.x += dx;
        self.y += dy;
    }

    fn take_damage(&mut self, amount: i32) -> bool {
        self.health = std::cmp::max(0, self.health - amount);
        self.health > 0
    }

    fn add_score(&mut self, points: i32) {
        self.score += points;
    }

    fn heal(&mut self) {
        if self.health < 100 {
            let heal_amount = std::cmp::min(20, 100 - self.health);
            self.health += heal_amount;
            println!("Healed for {} HP", heal_amount);
        } else {
            println!("Already at full health!");
        }
    }

    fn display_status(&self) {
        println!(
            "\n[{}] HP: {} | Score: {} | Level: {}",
            self.name, self.health, self.score, self.level
        );
    }
}

struct GameEngine {
    player: Player,
    running: bool,
}

impl GameEngine {
    fn new(player: Player) -> Self {
        GameEngine {
            player,
            running: true,
        }
    }

    fn run(&mut self) {
        println!("\n=== Rust Game Engine ===");
        println!("Welcome to the Rust Game!\n");

        while self.running && self.player.health > 0 {
            self.player.display_status();
            self.handle_input();
            self.update_game();
        }

        self.end_game();
    }

    fn handle_input(&mut self) {
        print!("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ");
        io::stdout().flush().unwrap();

        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();
        let command = input.trim().chars().next().unwrap_or('q');

        match command {
            'm' => {
                let mut rng = rand::thread_rng();
                let dx = rng.gen_range(-2..3);
                let dy = rng.gen_range(-2..3);
                self.player.move_player(dx, dy);
                println!("Moved to ({}, {})", self.player.x, self.player.y);
            }
            'a' => self.attack(),
            'h' => self.player.heal(),
            'q' => self.running = false,
            _ => println!("Unknown command"),
        }
    }

    fn attack(&mut self) {
        let mut rng = rand::thread_rng();
        let damage = rng.gen_range(10..31);
        println!("You attacked for {} damage!", damage);
        self.player.add_score(damage);
    }

    fn update_game(&mut self) {
        let mut rng = rand::thread_rng();
        if rng.gen::<f32>() < 0.1 {
            let damage = rng.gen_range(5..16);
            println!("\nEnemy attacked for {} damage!", damage);
            self.player.take_damage(damage);
        }
    }

    fn end_game(&self) {
        println!("\n=== GAME OVER ===");
        println!("Final Score: {}", self.player.score);
    }
}

fn main() {
    let mut name = String::new();
    print!("Enter your player name: ");
    io::stdout().flush().unwrap();
    io::stdin().read_line(&mut name).unwrap();

    let name = name.trim();
    let name = if name.is_empty() { "Hero" } else { name };

    let player = Player::new(name.to_string());
    let mut engine = GameEngine::new(player);
    engine.run();
}
