using System;
using System.Collections.Generic;

public class Player
{
    public string Name { get; set; }
    public int Health { get; set; }
    public int Score { get; set; }
    public int Level { get; set; }
    public int X { get; set; }
    public int Y { get; set; }

    public Player(string name)
    {
        Name = name ?? "Hero";
        Health = 100;
        Score = 0;
        Level = 1;
        X = 0;
        Y = 0;
    }

    public void Move(int dx, int dy)
    {
        X += dx;
        Y += dy;
    }

    public bool TakeDamage(int amount)
    {
        Health = Math.Max(0, Health - amount);
        return Health > 0;
    }

    public void AddScore(int points)
    {
        Score += points;
    }

    public void Heal()
    {
        if (Health < 100)
        {
            int healAmount = Math.Min(20, 100 - Health);
            Health += healAmount;
            Console.WriteLine($"Healed for {healAmount} HP");
        }
        else
        {
            Console.WriteLine("Already at full health!");
        }
    }

    public void DisplayStatus()
    {
        Console.WriteLine($"\n[{Name}] HP: {Health} | Score: {Score} | Level: {Level}");
        Console.WriteLine($"Position: ({X}, {Y})");
    }
}

public class GameEngine
{
    private Player player;
    private bool running;
    private Random random;

    public GameEngine(Player player)
    {
        this.player = player;
        this.running = true;
        this.random = new Random();
    }

    public void Run()
    {
        Console.WriteLine("\n=== C# Game Engine ===");
        Console.WriteLine("Welcome to the C# Game!\n");

        while (running && player.Health > 0)
        {
            player.DisplayStatus();
            HandleInput();
            UpdateGame();
        }

        EndGame();
    }

    private void HandleInput()
    {
        Console.Write("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ");
        string input = Console.ReadLine()?.ToLower() ?? "";

        if (!string.IsNullOrEmpty(input))
        {
            switch (input[0])
            {
                case 'm':
                    int dx = random.Next(-2, 3);
                    int dy = random.Next(-2, 3);
                    player.Move(dx, dy);
                    Console.WriteLine($"Moved to ({player.X}, {player.Y})");
                    break;
                case 'a':
                    Attack();
                    break;
                case 'h':
                    player.Heal();
                    break;
                case 'q':
                    running = false;
                    break;
                default:
                    Console.WriteLine("Unknown command");
                    break;
            }
        }
    }

    private void Attack()
    {
        int damage = random.Next(10, 31);
        Console.WriteLine($"You attacked for {damage} damage!");
        player.AddScore(damage);
    }

    private void UpdateGame()
    {
        if (random.NextDouble() < 0.15)
        {
            int damage = random.Next(5, 16);
            Console.WriteLine($"\nEnemy attacked for {damage} damage!");
            player.TakeDamage(damage);
        }
    }

    private void EndGame()
    {
        Console.WriteLine("\n=== GAME OVER ===");
        Console.WriteLine($"Final Score: {player.Score}");
    }
}

class Program
{
    static void Main()
    {
        Console.Write("Enter your player name: ");
        string name = Console.ReadLine();

        Player player = new Player(name);
        GameEngine engine = new GameEngine(player);
        engine.Run();
    }
}
