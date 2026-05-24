<?php

class Player {
    public $name;
    public $health;
    public $score;
    public $level;
    public $x;
    public $y;

    public function __construct($name) {
        $this->name = $name ?: 'Hero';
        $this->health = 100;
        $this->score = 0;
        $this->level = 1;
        $this->x = 0;
        $this->y = 0;
    }

    public function move($dx, $dy) {
        $this->x += $dx;
        $this->y += $dy;
    }

    public function takeDamage($amount) {
        $this->health = max(0, $this->health - $amount);
        return $this->health > 0;
    }

    public function addScore($points) {
        $this->score += $points;
    }

    public function heal() {
        if ($this->health < 100) {
            $healAmount = min(20, 100 - $this->health);
            $this->health += $healAmount;
            echo "Healed for $healAmount HP\n";
        } else {
            echo "Already at full health!\n";
        }
    }

    public function displayStatus() {
        echo "\n[{$this->name}] HP: {$this->health} | Score: {$this->score} | Level: {$this->level}\n";
        echo "Position: ({$this->x}, {$this->y})\n";
    }
}

class GameEngine {
    private $player;
    private $running;

    public function __construct($player) {
        $this->player = $player;
        $this->running = true;
    }

    public function run() {
        echo "\n=== PHP Game Engine ===\n";
        echo "Welcome to the PHP Game!\n\n";

        while ($this->running && $this->player->health > 0) {
            $this->player->displayStatus();
            $this->handleInput();
            $this->updateGame();
        }

        $this->endGame();
    }

    private function handleInput() {
        echo "Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ";
        $input = trim(fgets(STDIN));

        if (!empty($input)) {
            $command = $input[0];
            switch ($command) {
                case 'm':
                    $dx = rand(-2, 2);
                    $dy = rand(-2, 2);
                    $this->player->move($dx, $dy);
                    echo "Moved to ({$this->player->x}, {$this->player->y})\n";
                    break;
                case 'a':
                    $this->attack();
                    break;
                case 'h':
                    $this->player->heal();
                    break;
                case 'q':
                    $this->running = false;
                    break;
                default:
                    echo "Unknown command\n";
            }
        }
    }

    private function attack() {
        $damage = rand(10, 30);
        echo "You attacked for $damage damage!\n";
        $this->player->addScore($damage);
    }

    private function updateGame() {
        if (rand(0, 100) / 100 < 0.15) {
            $damage = rand(5, 15);
            echo "\nEnemy attacked for $damage damage!\n";
            $this->player->takeDamage($damage);
        }
    }

    private function endGame() {
        echo "\n=== GAME OVER ===\n";
        echo "Final Score: {$this->player->score}\n";
    }
}

echo "Enter your player name: ";
$name = trim(fgets(STDIN));
$player = new Player($name);
$engine = new GameEngine($player);
$engine->run();
?>
