#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>
#include <string>

using namespace std;

struct Player {
    string name;
    int x, y;
    int health;
    int score;
    int level;
    
    Player(string n) : name(n), x(0), y(0), health(100), score(0), level(1) {}
    
    void move(int dx, int dy) {
        x += dx;
        y += dy;
    }
    
    bool takeDamage(int amount) {
        health -= amount;
        if (health < 0) health = 0;
        return health > 0;
    }
    
    void addScore(int points) {
        score += points;
    }
    
    void display() {
        cout << "[" << name << "] HP: " << health << " | Score: " 
             << score << " | Level: " << level << endl;
    }
};

class GameEngine {
private:
    Player* player;
    bool running;
    
public:
    GameEngine() : player(nullptr), running(true) {}
    
    ~GameEngine() {
        if (player) delete player;
    }
    
    void init() {
        srand(time(0));
        cout << "\n=== C++ Game Engine ===" << endl;
        cout << "Welcome to the C++ Game!\n" << endl;
        
        string name;
        cout << "Enter your player name: ";
        getline(cin, name);
        if (name.empty()) name = "Hero";
        
        player = new Player(name);
    }
    
    void run() {
        init();
        while (running && player->health > 0) {
            displayStatus();
            handleInput();
            updateGame();
        }
        endGame();
    }
    
    void displayStatus() {
        cout << "\n";
        player->display();
        cout << "Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ";
    }
    
    void handleInput() {
        char command;
        cin >> command;
        cin.ignore();
        
        switch(command) {
            case 'm':
                player->move(rand() % 5 - 2, rand() % 5 - 2);
                cout << "Moved to (" << player->x << ", " << player->y << ")" << endl;
                break;
            case 'a':
                attack();
                break;
            case 'h':
                heal();
                break;
            case 'q':
                running = false;
                break;
            default:
                cout << "Unknown command" << endl;
        }
    }
    
    void attack() {
        int damage = rand() % 21 + 10;
        cout << "You attacked for " << damage << " damage!" << endl;
        player->addScore(damage);
    }
    
    void heal() {
        if (player->health < 100) {
            int healAmount = min(20, 100 - player->health);
            player->health += healAmount;
            cout << "Healed for " << healAmount << " HP" << endl;
        } else {
            cout << "Already at full health!" << endl;
        }
    }
    
    void updateGame() {
        if ((rand() % 10) < 1) {
            int damage = rand() % 11 + 5;
            cout << "\nEnemy attacked for " << damage << " damage!" << endl;
            player->takeDamage(damage);
        }
    }
    
    void endGame() {
        cout << "\n=== GAME OVER ===" << endl;
        cout << "Final Score: " << player->score << endl;
    }
};

int main() {
    GameEngine engine;
    engine.run();
    return 0;
}
