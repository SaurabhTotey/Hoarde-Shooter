module logic.game;

import core.thread;
import logic.Bunny;
import logic.Entity;

enum ticksPerSecond = 20; ///How many game logic ticks occur in a second

/**
 * The actual class that handles running game logic
 */
class Game {

    bool isRunning; ///Whether the game is running or not
    Bunny mainPlayer; ///The main player is the bunny
    Entity[] otherEntities; ///All other entities in the game that aren't the main player are stored here

    /**
     * Returns a list of all the entities in the game
     */
    @property Entity[] allEntities() {
        return this.mainPlayer ~ this.otherEntities;
    }

    /**
     * Constructs a game and makes the player
     */
    this() {
        this.mainPlayer = new Bunny();
    }

    /**
     * Actually handles running the game
     */
    void run() {
        this.isRunning = true;
        while (this.isRunning) {
            foreach (entity; this.allEntities) {
                entity.onTick();
            }
            this.isRunning = mainPlayer.isValid;
            Thread.sleep(msecs(1000 / ticksPerSecond));
        }
    }

}