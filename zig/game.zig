const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

const Player = struct {
    name: []const u8,
    health: i32,
    score: i32,
    level: i32,
    x: i32,
    y: i32,

    fn init(allocator: std.mem.Allocator, name: []const u8) !Player {
        return Player{
            .name = try allocator.dupe(u8, if (name.len > 0) name else "Hero"),
            .health = 100,
            .score = 0,
            .level = 1,
            .x = 0,
            .y = 0,
        };
    }

    fn move(self: *Player, dx: i32, dy: i32) void {
        self.x += dx;
        self.y += dy;
    }

    fn takeDamage(self: *Player, amount: i32) bool {
        self.health -= amount;
        if (self.health < 0) self.health = 0;
        return self.health > 0;
    }

    fn addScore(self: *Player, points: i32) void {
        self.score += points;
    }

    fn heal(self: *Player) void {
        if (self.health < 100) {
            const healAmount = @min(20, 100 - self.health);
            self.health += healAmount;
            stdout.print("Healed for {} HP\n", .{healAmount}) catch {};
        } else {
            stdout.print("Already at full health!\n", .{}) catch {};
        }
    }

    fn displayStatus(self: *Player) void {
        stdout.print("\n[{s}] HP: {} | Score: {} | Level: {}\n", .{ self.name, self.health, self.score, self.level }) catch {};
        stdout.print("Position: ({}, {})\n", .{ self.x, self.y }) catch {};
    }
};

const GameEngine = struct {
    player: *Player,
    running: bool,
    prng: std.rand.DefaultPrng,

    fn init(player: *Player) GameEngine {
        return GameEngine{
            .player = player,
            .running = true,
            .prng = std.rand.DefaultPrng.init(@intCast(u64, std.time.milliTimestamp())),
        };
    }

    fn run(self: *GameEngine) !void {
        try stdout.print("\n=== Zig Game Engine ===\n", .{});
        try stdout.print("Welcome to the Zig Game!\n\n", .{});

        var buffer: [256]u8 = undefined;

        while (self.running and self.player.health > 0) {
            self.player.displayStatus();
            try stdout.print("Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ", .{});

            const input = stdin.readUntilDelimiter(&buffer, '\n') catch "";
            if (input.len > 0) {
                const command = input[0];
                switch (command) {
                    'm' => {
                        var rand = self.prng.random();
                        const dx: i32 = @intCast(i32, rand.intRangeAtMost(u32, 0, 5)) - 2;
                        const dy: i32 = @intCast(i32, rand.intRangeAtMost(u32, 0, 5)) - 2;
                        self.player.move(dx, dy);
                        try stdout.print("Moved to ({}, {})\n", .{ self.player.x, self.player.y });
                    },
                    'a' => try self.attack(),
                    'h' => self.player.heal(),
                    'q' => self.running = false,
                    else => try stdout.print("Unknown command\n", .{}),
                }
            }

            try self.updateGame();
        }

        try self.endGame();
    }

    fn attack(self: *GameEngine) !void {
        var rand = self.prng.random();
        const damage = @intCast(i32, rand.intRangeAtMost(u32, 10, 31));
        try stdout.print("You attacked for {} damage!\n", .{damage});
        self.player.addScore(damage);
    }

    fn updateGame(self: *GameEngine) !void {
        var rand = self.prng.random();
        if (rand.float(f32) < 0.15) {
            const damage = @intCast(i32, rand.intRangeAtMost(u32, 5, 16));
            try stdout.print("\nEnemy attacked for {} damage!\n", .{damage});
            _ = self.player.takeDamage(damage);
        }
    }

    fn endGame(self: *GameEngine) !void {
        try stdout.print("\n=== GAME OVER ===\n", .{});
        try stdout.print("Final Score: {}\n", .{self.player.score});
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    try stdout.print("Enter your player name: ", .{});
    var buffer: [256]u8 = undefined;
    const input = stdin.readUntilDelimiter(&buffer, '\n') catch "";

    var player = try Player.init(allocator, input);
    defer allocator.free(player.name);

    var engine = GameEngine.init(&player);
    try engine.run();
}
