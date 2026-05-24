import Foundation

struct Player {
    var name: String
    var health: Int = 100
    var score: Int = 0
    var level: Int = 1
    var x: Int = 0
    var y: Int = 0

    mutating func move(dx: Int, dy: Int) {
        x += dx
        y += dy
    }

    mutating func takeDamage(_ amount: Int) -> Bool {
        health = max(0, health - amount)
        return health > 0
    }

    mutating func addScore(_ points: Int) {
        score += points
    }

    mutating func heal() {
        if health < 100 {
            let healAmount = min(20, 100 - health)
            health += healAmount
            print("Healed for \(healAmount) HP")
        } else {
            print("Already at full health!")
        }
    }

    func displayStatus() {
        print("\n[\(name)] HP: \(health) | Score: \(score) | Level: \(level)")
        print("Position: (\(x), \(y))")
    }
}

class GameEngine {
    var player: Player
    var running: Bool = true

    init(player: Player) {
        self.player = player
    }

    func run() {
        print("\n=== Swift Game Engine ===")
        print("Welcome to the Swift Game!\n")

        while running && player.health > 0 {
            player.displayStatus()
            handleInput()
            updateGame()
        }

        endGame()
    }

    private func handleInput() {
        print("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ", terminator: "")
        fflush(stdout)

        if let input = readLine()?.lowercased(), let command = input.first {
            switch command {
            case "m":
                let dx = Int.random(in: -2...2)
                let dy = Int.random(in: -2...2)
                player.move(dx: dx, dy: dy)
                print("Moved to (\(player.x), \(player.y))")
            case "a":
                attack()
            case "h":
                player.heal()
            case "q":
                running = false
            default:
                print("Unknown command")
            }
        }
    }

    private func attack() {
        let damage = Int.random(in: 10...30)
        print("You attacked for \(damage) damage!")
        player.addScore(damage)
    }

    private func updateGame() {
        if Double.random(in: 0.0..<1.0) < 0.15 {
            let damage = Int.random(in: 5...15)
            print("\nEnemy attacked for \(damage) damage!")
            _ = player.takeDamage(damage)
        }
    }

    private func endGame() {
        print("\n=== GAME OVER ===")
        print("Final Score: \(player.score)")
    }
}

let playerName = {
    print("Enter your player name: ", terminator: "")
    fflush(stdout)
    return readLine() ?? ""
}()

var player = Player(name: playerName.isEmpty ? "Hero" : playerName)
let engine = GameEngine(player: player)
engine.run()
