import java.util.Scanner;
import java.util.Random;

public class Game {
    static class Player {
        String name;
        int health;
        int score;
        int level;
        int x;
        int y;

        Player(String name) {
            this.name = name;
            this.health = 100;
            this.score = 0;
            this.level = 1;
            this.x = 0;
            this.y = 0;
        }

        void move(int dx, int dy) {
            x += dx;
            y += dy;
        }

        boolean takeDamage(int amount) {
            health -= amount;
            if (health < 0) health = 0;
            return health > 0;
        }

        void addScore(int points) {
            score += points;
        }

        void heal() {
            if (health < 100) {
                int healAmount = Math.min(20, 100 - health);
                health += healAmount;
                System.out.println("Healed for " + healAmount + " HP");
            } else {
                System.out.println("Already at full health!");
            }
        }

        void displayStatus() {
            System.out.println("\n[" + name + "] HP: " + health + " | Score: " + score + " | Level: " + level);
            System.out.println("Position: (" + x + ", " + y + ")");
        }
    }

    static class GameEngine {
        Player player;
        boolean running;
        Random random;

        GameEngine(Player player) {
            this.player = player;
            this.running = true;
            this.random = new Random();
        }

        void run() {
            System.out.println("\n=== Java Game Engine ===");
            System.out.println("Welcome to the Java Game!\n");

            Scanner scanner = new Scanner(System.in);

            while (running && player.health > 0) {
                player.displayStatus();
                System.out.print("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ");

                String input = scanner.nextLine().toLowerCase();
                if (!input.isEmpty()) {
                    char command = input.charAt(0);
                    switch (command) {
                        case 'm':
                            int dx = random.nextInt(5) - 2;
                            int dy = random.nextInt(5) - 2;
                            player.move(dx, dy);
                            System.out.println("Moved to (" + player.x + ", " + player.y + ")");
                            break;
                        case 'a':
                            attack();
                            break;
                        case 'h':
                            player.heal();
                            break;
                        case 'q':
                            running = false;
                            break;
                        default:
                            System.out.println("Unknown command");
                    }
                }

                updateGame();
            }

            endGame();
            scanner.close();
        }

        void attack() {
            int damage = random.nextInt(21) + 10;
            System.out.println("You attacked for " + damage + " damage!");
            player.addScore(damage);
        }

        void updateGame() {
            if (random.nextFloat() < 0.15f) {
                int damage = random.nextInt(11) + 5;
                System.out.println("\nEnemy attacked for " + damage + " damage!");
                player.takeDamage(damage);
            }
        }

        void endGame() {
            System.out.println("\n=== GAME OVER ===");
            System.out.println("Final Score: " + player.score);
        }
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter your player name: ");
        String name = scanner.nextLine();
        if (name.trim().isEmpty()) {
            name = "Hero";
        }

        Player player = new Player(name);
        GameEngine engine = new GameEngine(player);
        engine.run();
        scanner.close();
    }
}
