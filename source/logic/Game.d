module logic.game;

import std.algorithm;
import std.array;
import std.parallelism;
import core.thread;
import d2d;
import logic.Bunny;
import logic.Entity;

enum ticksPerSecond = 30; ///How many game logic ticks occur in a second

/**
 * The actual class that handles running game logic
 */
class Game {

    private bool _isRunning; ///Whether the game is running or not
    Bunny mainPlayer; ///The main player is the bunny
    private Entity[] otherEntities; ///All other entities in the game that aren't the main player are stored here

    /**
     * Sets whether the game is running; if set to true, starts the game; otherwise, the game will come to a stop
     * Stopping the game doesn't mean it's done: it can be resumed by setting this to true again if the player is alive
     */
    @property void isRunning(bool state) {
        if (state) {
            if (!this._isRunning) {
                this.run();
            }
        }
        else {
            this._isRunning = false;
        }
    }

    /**
     * Gets whether the game is running
     * Even if the game is stopped, it can be resumed as long as the player is alive
     */
    @property bool isRunning() {
        return this._isRunning;
    }

    /**
     * Returns a list of all the entities in the game
     */
    @property Entity[] allEntities() {
        return this.otherEntities ~ this.mainPlayer;
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
    private void run() {
        this._isRunning = true;
        while (this._isRunning) {
            foreach (entity; this.allEntities.parallel) {
                entity.onTick();
            }
            foreach (entity1; this.allEntities.parallel) {
                foreach (entity2; this.allEntities.parallel) {
                    if (intersects!(dRectangle, dRectangle)(entity1.location, entity2.location)) {
                        entity1.onCollide(entity2);
                    }
                }
            }
            foreach (entity; this.allEntities.parallel) {
                if (entity.spawnQueue.length > 0) {
                    this.otherEntities = this.otherEntities ~ entity.spawnQueue;
                    entity.spawnQueue = null;
                }
            }
            this.otherEntities = this.otherEntities.filter!(entity => entity.isValid).array;
            this._isRunning = mainPlayer.isValid;
            Thread.sleep(msecs(1000 / ticksPerSecond));
        }
    }

}
