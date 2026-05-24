(ns game.core
  (:gen-class))

(defrecord Player [name health score level x y])

(defn create-player [name]
  (map->Player {:name (or (if (empty? name) nil name) "Hero")
                          :health 100
                          :score 0
                          :level 1
                          :x 0
                          :y 0}))

(defn move [player dx dy]
  (update player :x + dx)
  (update player :y + dy))

(defn take-damage [player amount]
  (update player :health (fn [h] (max 0 (- h amount)))))

(defn add-score [player points]
  (update player :score + points))

(defn heal [player]
  (if (< (:health player) 100)
    (let [heal-amount (min 20 (- 100 (:health player)))]
      (println (str "Healed for " heal-amount " HP"))
      (update player :health + heal-amount))
    (do (println "Already at full health!")
        player)))

(defn display-status [player]
  (println (str "\n[" (:name player) "] HP: " (:health player) 
                " | Score: " (:score player) " | Level: " (:level player)))
  (println (str "Position: (" (:x player) ", " (:y player) ")")))

(defn handle-input [player]
  (println "Commands: (m)ove, (a)ttack, (h)eal, (q)uit: ")
  (let [command (read-line)]
    (case (if (empty? command) "" (subs command 0 1))
      "m" (let [dx (- (rand-int 5) 2)
                 dy (- (rand-int 5) 2)]
             (println (str "Moved to (" (+ (:x player) dx) ", " (+ (:y player) dy) ")"))
             (-> player
                 (update :x + dx)
                 (update :y + dy)))
      "a" (let [damage (+ (rand-int 21) 10)]
            (println (str "You attacked for " damage " damage!"))
            (add-score player damage))
      "h" (heal player)
      "q" (assoc player :health 0)
      (do (println "Unknown command")
          player))))

(defn random-event [player]
  (if (< (rand) 0.15)
    (let [damage (+ (rand-int 11) 5)]
      (println (str "\nEnemy attacked for " damage " damage!"))
      (take-damage player damage))
    player))

(defn game-loop [player]
  (display-status player)
  (if (<= (:health player) 0)
    (println "\n=== GAME OVER ===\nFinal Score: " (:score player))
    (recur (-> player
               (handle-input)
               (random-event)))))

(defn -main [& args]
  (println "\n=== Clojure Game Engine ===")
  (println "Welcome to the Clojure Game!\n")
  (println "Enter your player name: ")
  (let [name (read-line)
        player (create-player name)]
    (game-loop player)))
