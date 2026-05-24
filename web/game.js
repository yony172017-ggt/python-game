// Python Game - Web Edition Game Logic

class WebGame {
    constructor() {
        this.player = {
            name: 'Hero',
            health: 100,
            maxHealth: 100,
            score: 0,
            level: 1,
            x: 0,
            y: 0
        };
        
        this.stats = {
            totalDamage: 0,
            enemiesDefeated: 0,
            timesHealed: 0,
            startTime: Date.now()
        };
        
        this.updateDisplay();
        this.startGameTimer();
    }
    
    updateDisplay() {
        document.getElementById('playerName').textContent = this.player.name;
        document.getElementById('health').textContent = this.player.health;
        document.getElementById('score').textContent = this.player.score;
        document.getElementById('level').textContent = this.player.level;
        document.getElementById('posX').textContent = this.player.x;
        document.getElementById('posY').textContent = this.player.y;
        
        document.getElementById('totalDamage').textContent = this.stats.totalDamage;
        document.getElementById('enemiesDefeated').textContent = this.stats.enemiesDefeated;
        document.getElementById('timesHealed').textContent = this.stats.timesHealed;
    }
    
    addLog(message, type = 'info') {
        const logBox = document.getElementById('gameLog');
        const entry = document.createElement('p');
        entry.className = `log-entry ${type}`;
        entry.textContent = `[${this.getTime()}] ${message}`;
        logBox.appendChild(entry);
        logBox.scrollTop = logBox.scrollHeight;
    }
    
    getTime() {
        const now = new Date();
        return now.toLocaleTimeString();
    }
    
    movePlayer() {
        const dx = Math.floor(Math.random() * 5) - 2;
        const dy = Math.floor(Math.random() * 5) - 2;
        
        this.player.x += dx;
        this.player.y += dy;
        
        this.addLog(`Moved to (${this.player.x}, ${this.player.y})`, 'info');
        this.updateDisplay();
        this.randomEnemyAttack();
    }
    
    attack() {
        const damage = Math.floor(Math.random() * 21) + 10;
        this.player.score += damage;
        this.stats.totalDamage += damage;
        
        this.addLog(`⚔️ You attacked for ${damage} damage!`, 'attack');
        this.updateDisplay();
        
        if (this.player.score >= 200) {
            this.levelUp();
        }
        
        this.randomEnemyAttack();
    }
    
    heal() {
        if (this.player.health < this.player.maxHealth) {
            const healAmount = Math.min(20, this.player.maxHealth - this.player.health);
            this.player.health += healAmount;
            this.stats.timesHealed += 1;
            
            this.addLog(`❤️ Healed for ${healAmount} HP!`, 'heal');
            this.updateDisplay();
        } else {
            this.addLog('Already at full health!', 'info');
        }
        
        this.randomEnemyAttack();
    }
    
    randomEnemyAttack() {
        if (Math.random() < 0.3) {
            const damage = Math.floor(Math.random() * 11) + 5;
            this.player.health = Math.max(0, this.player.health - damage);
            
            this.addLog(`👹 Enemy attacked for ${damage} damage!`, 'damage');
            this.updateDisplay();
            
            if (this.player.health <= 0) {
                this.gameOver();
            }
        }
    }
    
    levelUp() {
        this.player.level += 1;
        this.player.score = 0;
        this.player.health = this.player.maxHealth;
        this.stats.enemiesDefeated += 1;
        
        this.addLog(`🎊 LEVEL UP! Now level ${this.player.level}!`, 'info');
        this.updateDisplay();
    }
    
    gameOver() {
        this.addLog(`💀 GAME OVER! Final Score: ${this.player.score}`, 'damage');
        document.querySelectorAll('.btn').forEach(btn => {
            btn.disabled = true;
        });
    }
    
    resetGame() {
        this.player = {
            name: document.getElementById('playerNameInput').value || 'Hero',
            health: 100,
            maxHealth: 100,
            score: 0,
            level: 1,
            x: 0,
            y: 0
        };
        
        this.stats = {
            totalDamage: 0,
            enemiesDefeated: 0,
            timesHealed: 0,
            startTime: Date.now()
        };
        
        document.getElementById('gameLog').innerHTML = '<p class="log-entry">Game reset. Welcome!</p>';
        document.querySelectorAll('.btn').forEach(btn => {
            btn.disabled = false;
        });
        
        this.updateDisplay();
        this.addLog('Game reset and ready to play!', 'info');
    }
    
    setPlayerName() {
        const input = document.getElementById('playerNameInput').value.trim();
        if (input) {
            this.player.name = input;
            this.addLog(`Player name changed to: ${input}`, 'info');
            this.updateDisplay();
        }
    }
    
    startGameTimer() {
        setInterval(() => {
            const elapsed = Math.floor((Date.now() - this.stats.startTime) / 1000);
            document.getElementById('gameTime').textContent = `${elapsed}s`;
        }, 1000);
    }
}

// Initialize game on page load
let game;
document.addEventListener('DOMContentLoaded', () => {
    game = new WebGame();
});

// Game control functions
function movePlayer() {
    game.movePlayer();
}

function attack() {
    game.attack();
}

function heal() {
    game.heal();
}

function resetGame() {
    if (confirm('Are you sure you want to reset the game?')) {
        game.resetGame();
    }
}

function setPlayerName() {
    game.setPlayerName();
}
