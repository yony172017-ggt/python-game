local Player = {}
Player.__index = Player

function Player:new(name)
    local self = setmetatable({}, Player)
    self.name = name or "Hero"
    self.health = 100
    self.score = 0
    self.level = 1
    self.x = 0
    self.y = 0
    return self
end

function Player:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Player:take_damage(amount)
    self.health = math.max(0, self.health - amount)
    return self.health > 0
end

function Player:add_score(points)
    self.score = self.score + points
end

function Player:heal()
    if self.health < 100 then
        local heal_amount = math.min(20, 100 - self.health)
        self.health = self.health + heal_amount
        print(string.format("Healed for %d HP", heal_amount))
    else
        print("Already at full health!")
    end
end

function Player:display_status()
    print(string.format("\n[%s] HP: %d | Score: %d | Level: %d", self.name, self.health, self.score, self.level))
    print(string.format("Position: (%d, %d)", self.x, self.y))
end

local GameEngine = {}
GameEngine.__index = GameEngine

function GameEngine:new(player)
    local self = setmetatable({}, GameEngine)
    self.player = player
    self.running = true
    return self
end

function GameEngine:run()
    print("\n=== Lua Game Engine ===")
    print("Welcome to the Lua Game!\n")

    while self.running and self.player.health > 0 do
        self.player:display_status()
        self:handle_input()
        self:update_game()
    end

    self:end_game()
end

function GameEngine:handle_input()
    io.write("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ")
    local input = io.read():lower()

    if input:len() > 0 then
        local command = input:sub(1, 1)
        if command == "m" then
            local dx = math.random(-2, 2)
            local dy = math.random(-2, 2)
            self.player:move(dx, dy)
            print(string.format("Moved to (%d, %d)", self.player.x, self.player.y))
        elseif command == "a" then
            self:attack()
        elseif command == "h" then
            self.player:heal()
        elseif command == "q" then
            self.running = false
        else
            print("Unknown command")
        end
    end
end

function GameEngine:attack()
    local damage = math.random(10, 30)
    print(string.format("You attacked for %d damage!", damage))
    self.player:add_score(damage)
end

function GameEngine:update_game()
    if math.random() < 0.15 then
        local damage = math.random(5, 15)
        print(string.format("\nEnemy attacked for %d damage!", damage))
        self.player:take_damage(damage)
    end
end

function GameEngine:end_game()
    print("\n=== GAME OVER ===")
    print(string.format("Final Score: %d", self.player.score))
end

-- Main
math.randomseed(os.time())
io.write("Enter your player name: ")
local name = io.read()
local player = Player:new(name)
local engine = GameEngine:new(player)
engine:run()
