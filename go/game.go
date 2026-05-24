package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"strings"
	"time"
)

type Player struct {
	Name   string
	Health int
	Score  int
	Level  int
	X      int
	Y      int
}

func (p *Player) Move(dx, dy int) {
	p.X += dx
	p.Y += dy
}

func (p *Player) TakeDamage(amount int) bool {
	p.Health -= amount
	if p.Health < 0 {
		p.Health = 0
	}
	return p.Health > 0
}

func (p *Player) AddScore(points int) {
	p.Score += points
}

func (p *Player) Heal() {
	if p.Health < 100 {
		healAmount := 20
		if p.Health+healAmount > 100 {
			healAmount = 100 - p.Health
		}
		p.Health += healAmount
		fmt.Printf("Healed for %d HP\n", healAmount)
	} else {
		fmt.Println("Already at full health!")
	}
}

func (p *Player) DisplayStatus() {
	fmt.Printf("\n[%s] HP: %d | Score: %d | Level: %d\n", p.Name, p.Health, p.Score, p.Level)
	fmt.Printf("Position: (%d, %d)\n", p.X, p.Y)
}

type GameEngine struct {
	Player *Player
	Running bool
}

func NewGameEngine(player *Player) *GameEngine {
	return &GameEngine{
		Player: player,
		Running: true,
	}
}

func (g *GameEngine) Run() {
	fmt.Println("\n=== Go Game Engine ===")
	fmt.Println("Welcome to the Go Game!\n")

	reader := bufio.NewReader(os.Stdin)

	for g.Running && g.Player.Health > 0 {
		g.Player.DisplayStatus()
		fmt.Print("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ")

		input, _ := reader.ReadString('\n')
		command := strings.TrimSpace(input)

		if len(command) > 0 {
			switch command[0] {
			case 'm':
				dx := rand.Intn(5) - 2
				dy := rand.Intn(5) - 2
				g.Player.Move(dx, dy)
				fmt.Printf("Moved to (%d, %d)\n", g.Player.X, g.Player.Y)
			case 'a':
				g.Attack()
			case 'h':
				g.Player.Heal()
			case 'q':
				g.Running = false
			default:
				fmt.Println("Unknown command")
			}
		}

		g.UpdateGame()
	}

	g.EndGame()
}

func (g *GameEngine) Attack() {
	damage := rand.Intn(21) + 10
	fmt.Printf("You attacked for %d damage!\n", damage)
	g.Player.AddScore(damage)
}

func (g *GameEngine) UpdateGame() {
	if rand.Float32() < 0.15 {
		damage := rand.Intn(11) + 5
		fmt.Printf("\nEnemy attacked for %d damage!\n", damage)
		g.Player.TakeDamage(damage)
	}
}

func (g *GameEngine) EndGame() {
	fmt.Println("\n=== GAME OVER ===")
	fmt.Printf("Final Score: %d\n", g.Player.Score)
}

func main() {
	rand.Seed(time.Now().UnixNano())

	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter your player name: ")
	name, _ := reader.ReadString('\n')
	name = strings.TrimSpace(name)

	if name == "" {
		name = "Hero"
	}

	player := &Player{
		Name:   name,
		Health: 100,
		Score:  0,
		Level:  1,
	}

	engine := NewGameEngine(player)
	engine.Run()
}
