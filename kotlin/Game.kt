import kotlin.random.Random
import java.util.Scanner

data class Player(
    var name: String,
    var health: Int = 100,
    var score: Int = 0,
    var level: Int = 1,
    var x: Int = 0,
    var y: Int = 0
) {
    fun move(dx: Int, dy: Int) {
        x += dx
        y += dy
    }

    fun takeDamage(amount: Int): Boolean {
        health = maxOf(0, health - amount)
        return health > 0
    }

    fun addScore(points: Int) {
        score += points
    }

    fun heal() {
        if (health < 100) {
            val healAmount = minOf(20, 100 - health)
            health += healAmount
            println("Healed for $healAmount HP")
        } else {
            println("Already at full health!")
        }
    }

    fun displayStatus() {
        println("\n[$name] HP: $health | Score: $score | Level: $level")
        println("Position: ($x, $y)")
    }
}

class GameEngine(val player: Player) {
    private var running = true
    private val random = Random

    fun run() {
        println("\n=== Kotlin Game Engine ===")
        println("Welcome to the Kotlin Game!\n")

        val scanner = Scanner(System.`in`)

        while (running && player.health > 0) {
            player.displayStatus()
            print("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ")

            val input = scanner.nextLine().lowercase()
            if (input.isNotEmpty()) {
                when (input.first()) {
                    'm' -> {
                        val dx = random.nextInt(-2, 3)
                        val dy = random.nextInt(-2, 3)
                        player.move(dx, dy)
                        println("Moved to (${player.x}, ${player.y})")
                    }
                    'a' -> attack()
                    'h' -> player.heal()
                    'q' -> running = false
                    else -> println("Unknown command")
                }
            }

            updateGame()
        }

        endGame()
        scanner.close()
    }

    private fun attack() {
        val damage = random.nextInt(10, 31)
        println("You attacked for $damage damage!")
        player.addScore(damage)
    }

    private fun updateGame() {
        if (random.nextFloat() < 0.15f) {
            val damage = random.nextInt(5, 16)
            println("\nEnemy attacked for $damage damage!")
            player.takeDamage(damage)
        }
    }

    private fun endGame() {
        println("\n=== GAME OVER ===")
        println("Final Score: ${player.score}")
    }
}

fun main() {
    val scanner = Scanner(System.`in`)
    print("Enter your player name: ")
    val name = scanner.nextLine().takeIf { it.isNotEmpty() } ?: "Hero"

    val player = Player(name)
    val engine = GameEngine(player)
    engine.run()
    scanner.close()
}
