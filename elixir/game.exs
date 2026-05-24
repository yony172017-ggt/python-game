defmodule Player do
  defstruct name: "Hero", health: 100, score: 0, level: 1, x: 0, y: 0

  def move(player, dx, dy) do
    %{player | x: player.x + dx, y: player.y + dy}
  end

  def take_damage(player, amount) do
    new_health = max(0, player.health - amount)
    %{player | health: new_health}
  end

  def add_score(player, points) do
    %{player | score: player.score + points}
  end

  def heal(player) do
    if player.health < 100 do
      heal_amount = min(20, 100 - player.health)
      IO.puts("Healed for #{heal_amount} HP")
      %{player | health: player.health + heal_amount}
    else
      IO.puts("Already at full health!")
      player
    end
  end

  def display_status(player) do
    IO.puts("\n[#{player.name}] HP: #{player.health} | Score: #{player.score} | Level: #{player.level}")
    IO.puts("Position: (#{player.x}, #{player.y})")
  end
end

defmodule GameEngine do
  def run do
    IO.puts("\n=== Elixir Game Engine ===")
    IO.puts("Welcome to the Elixir Game!\n")

    name = IO.gets("Enter your player name: ") |> String.trim()
    name = if name == "", do: "Hero", else: name

    player = %Player{name: name}
    game_loop(player)
  end

  defp game_loop(player) when player.health <= 0 do
    IO.puts("\n=== GAME OVER ===")
    IO.puts("Final Score: #{player.score}")
  end

  defp game_loop(player) do
    Player.display_status(player)
    command = IO.gets("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ") |> String.trim()

    new_player =
      case command do
        "m" ->
          dx = Enum.random(-2..2)
          dy = Enum.random(-2..2)
          player = Player.move(player, dx, dy)
          IO.puts("Moved to (#{player.x}, #{player.y})")
          player

        "a" ->
          damage = Enum.random(10..30)
          IO.puts("You attacked for #{damage} damage!")
          Player.add_score(player, damage)

        "h" ->
          Player.heal(player)

        "q" ->
          %{player | health: 0}

        _ ->
          IO.puts("Unknown command")
          player
      end

    new_player = update_game(new_player)
    game_loop(new_player)
  end

  defp update_game(player) do
    if :rand.uniform() < 0.15 do
      damage = Enum.random(5..15)
      IO.puts("\nEnemy attacked for #{damage} damage!")
      Player.take_damage(player, damage)
    else
      player
    end
  end
end

GameEngine.run()
