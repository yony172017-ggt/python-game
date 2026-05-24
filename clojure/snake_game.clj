(ns snake-game.core
  (:require [clojure.core.async :as async]
            [clojure.java.io :as io])
  (:import (javax.swing JFrame JPanel)
           (java.awt Color Graphics2D RenderingHints)
           (java.awt.event KeyListener KeyEvent)
           (java.util.concurrent ScheduledExecutorService Executors TimeUnit)))

(def game-state (atom {
  :snake [(vec [16 12])]
  :direction [1 0]
  :next-direction [1 0]
  :food [(rand-int 32) (rand-int 24)]
  :score 0
  :game-over false
  :width 640
  :height 480
  :block-size 20
  :grid-width 32
  :grid-height 24
}))

(defn spawn-food []
  "Spawn food at a random location not occupied by snake"
  (let [{:keys [snake grid-width grid-height]} @game-state]
    (loop []
      (let [new-food [(rand-int grid-width) (rand-int grid-height)]]
        (if (some #{new-food} snake)
          (recur)
          new-food)))))

(defn reset-game []
  "Reset game state"
  (swap! game-state assoc
    :snake [(vec [16 12])]
    :direction [1 0]
    :next-direction [1 0]
    :food (spawn-food)
    :score 0
    :game-over false))

(defn opposite-direction? [d1 d2]
  "Check if two directions are opposite"
  (= (mapv - d1) d2))

(defn update-game []
  "Update game state"
  (let [{:keys [snake direction next-direction food score game-over grid-width grid-height]} @game-state]
    (when-not game-over
      (let [new-dir next-direction
            [head-x head-y] (first snake)
            [dx dy] new-dir
            new-head [(+ head-x dx) (+ head-y dy)]
            [nx ny] new-head]
        
        (cond
          ; Wall collision
          (or (< nx 0) (>= nx grid-width) (< ny 0) (>= ny grid-height))
          (swap! game-state assoc :game-over true)
          
          ; Self collision
          (some #{new-head} snake)
          (swap! game-state assoc :game-over true)
          
          ; Food collision
          (= new-head food)
          (do
            (swap! game-state assoc
              :snake (cons new-head snake)
              :direction new-dir
              :food (spawn-food)
              :score (+ score 10)))
          
          ; Normal move
          :else
          (swap! game-state assoc
            :snake (vec (cons new-head (butlast snake)))
            :direction new-dir))))))

(defn draw-game [^Graphics2D g width height block-size]
  "Render the game"
  (let [{:keys [snake food score game-over]} @game-state]
    ; Clear screen
    (.setColor g Color/BLACK)
    (.fillRect g 0 0 width height)
    
    ; Draw snake
    (.setColor g Color/GREEN)
    (doseq [[[x y] idx] (map vector snake (range))]
      (if (= idx 0)
        (.setColor g (Color. 0 255 0))
        (.setColor g (Color. 0 200 0)))
      (.fillRect g (* x block-size) (* y block-size) (dec block-size) (dec block-size)))
    
    ; Draw food
    (.setColor g Color/RED)
    (let [[fx fy] food]
      (.fillRect g (* fx block-size) (* fy block-size) (dec block-size) (dec block-size)))
    
    ; Draw score
    (.setColor g Color/WHITE)
    (.setFont g (java.awt.Font. "Arial" java.awt.Font/PLAIN 36))
    (.drawString g (str "Score: " score) 10 30)
    
    ; Draw game over message
    (when game-over
      (.setColor g Color/RED)
      (.setFont g (java.awt.Font. "Arial" java.awt.Font/BOLD 48))
      (.drawString g "GAME OVER!" 150 240)
      (.setColor g Color/WHITE)
      (.setFont g (java.awt.Font. "Arial" java.awt.Font/PLAIN 24))
      (.drawString g "Press R to restart or Q to quit" 170 300))))

(defn create-game-panel []
  "Create the game panel"
  (let [{:keys [width height block-size]} @game-state
        panel (proxy [JPanel KeyListener] []
          (paintComponent [g]
            (proxy-super paintComponent g)
            (draw-game g width height block-size))
          
          (keyPressed [e]
            (let [{:keys [direction game-over]} @game-state
                  key-code (.getKeyCode e)]
              (cond
                (= key-code KeyEvent/VK_UP)
                (when (not= direction [0 1])
                  (swap! game-state assoc :next-direction [0 -1]))
                
                (= key-code KeyEvent/VK_DOWN)
                (when (not= direction [0 -1])
                  (swap! game-state assoc :next-direction [0 1]))
                
                (= key-code KeyEvent/VK_LEFT)
                (when (not= direction [1 0])
                  (swap! game-state assoc :next-direction [-1 0]))
                
                (= key-code KeyEvent/VK_RIGHT)
                (when (not= direction [-1 0])
                  (swap! game-state assoc :next-direction [1 0]))
                
                (and (= key-code KeyEvent/VK_R) game-over)
                (reset-game)
                
                (= key-code KeyEvent/VK_Q)
                (System/exit 0))))
          
          (keyReleased [e])
          (keyTyped [e]))]
    
    (.setFocusable panel true)
    (.addKeyListener panel panel)
    panel))

(defn create-frame []
  "Create the game window"
  (let [{:keys [width height]} @game-state
        frame (JFrame. "Snake Game")
        panel (create-game-panel)]
    
    (.setSize frame width height)
    (.setLocationRelativeTo frame nil)
    (.setDefaultCloseOperation frame JFrame/EXIT_ON_CLOSE)
    (.add frame panel)
    (.setVisible frame true)
    
    ; Start game loop
    (let [executor (Executors/newScheduledThreadPool 1)]
      (.scheduleAtFixedRate executor
        (fn []
          (update-game)
          (.repaint panel))
        0
        100
        TimeUnit/MILLISECONDS))
    
    frame))

(defn -main []
  "Main entry point"
  (create-frame))

(when (= *ns* (find-ns 'user))
  (-main))
