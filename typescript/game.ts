import * as readline from 'readline';

interface IPlayer {
    name: string;
    health: number;
    score: number;
    level: number;
    x: number;
    y: number;
}

class Player implements IPlayer {
    name: string;
    health: number = 100;
    score: number = 0;
    level: number = 1;
    x: number = 0;
    y: number = 0;

    constructor(name: string) {
        this.name = name || 'Hero';
    }

    move(dx: number, dy: number): void {
        this.x += dx;
        this.y += dy;
    }

    takeDamage(amount: number): boolean {
        this.health = Math.max(0, this.health - amount);
        return this.health > 0;
    }

    addScore(points: number): void {
        this.score += points;
    }

    heal(): void {
        if (this.health < 100) {
            const healAmount = Math.min(20, 100 - this.health);
            this.health += healAmount;
            console.log(`Healed for ${healAmount} HP`);
        } else {
            console.log('Already at full health!');
        }
    }

    displayStatus(): void {
        console.log(`\n[${this.name}] HP: ${this.health} | Score: ${this.score} | Level: ${this.level}`);
        console.log(`Position: (${this.x}, ${this.y})`);
    }
}

class GameEngine {
    private player: Player;
    private running: boolean = true;
    private rl: readline.Interface;

    constructor(player: Player) {
        this.player = player;
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
    }

    async run(): Promise<void> {
        console.log('\n=== TypeScript Game Engine ===');
        console.log('Welcome to the TypeScript Game!\n');

        while (this.running && this.player.health > 0) {
            this.player.displayStatus();
            await this.handleInput();
            this.updateGame();
        }

        this.endGame();
        this.rl.close();
    }

    private handleInput(): Promise<void> {
        return new Promise((resolve) => {
            this.rl.question('Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ', (input: string) => {
                const command = input.toLowerCase().trim()[0];
                switch (command) {
                    case 'm':
                        const dx = Math.floor(Math.random() * 5) - 2;
                        const dy = Math.floor(Math.random() * 5) - 2;
                        this.player.move(dx, dy);
                        console.log(`Moved to (${this.player.x}, ${this.player.y})`);
                        break;
                    case 'a':
                        this.attack();
                        break;
                    case 'h':
                        this.player.heal();
                        break;
                    case 'q':
                        this.running = false;
                        break;
                    default:
                        console.log('Unknown command');
                }
                resolve();
            });
        });
    }

    private attack(): void {
        const damage = Math.floor(Math.random() * 21) + 10;
        console.log(`You attacked for ${damage} damage!`);
        this.player.addScore(damage);
    }

    private updateGame(): void {
        if (Math.random() < 0.15) {
            const damage = Math.floor(Math.random() * 11) + 5;
            console.log(`\nEnemy attacked for ${damage} damage!`);
            this.player.takeDamage(damage);
        }
    }

    private endGame(): void {
        console.log('\n=== GAME OVER ===');
        console.log(`Final Score: ${this.player.score}`);
    }
}

async function main(): Promise<void> {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question('Enter your player name: ', (name: string) => {
        rl.close();
        const player = new Player(name);
        const engine = new GameEngine(player);
        engine.run();
    });
}

main().catch(console.error);
