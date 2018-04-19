module logic.Game;

import std.algorithm;
import std.array;
import core.thread;
import d2d;
import logic.Bunny;
import logic.Entity;
import logic.Event;
import logic.Wolf;

enum ticksPerSecond = 30; ///How many game logic ticks occur in a second

/**
 * The actual class that handles running game logic
 */
class Game {

    int difficulty; ///How current difficulty or hardness the game is
    int _totalDifficulty; ///How hard the game has been in total
    private bool _isRunning; ///Whether the game is running or not
    Bunny mainPlayer; ///The main player is the bunny
    private Entity[] otherEntities; ///All other entities in the game that aren't the main player are stored here
    private Event[] _allEvents; ///All the game events that happened over the duration of the game

    /**
     * Sets whether the game is running; if set to true, starts the game; otherwise, the game will come to a stop
     * Stopping the game doesn't mean it's done: it can be resumed by setting this to true again if the player is alive
     */
    @property void isRunning(bool state) {
        if (state) {
            if (!this._isRunning && this.mainPlayer.isValid) {
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
     * Returns the list of all of the game events
     */
    @property Event[] allEvents() {
        return this._allEvents;
    }

    /**
     * Returns all unchecked game events
     */
    @property Event[] currentEvents() {
        return this._allEvents.filter!(event => !event.consumed).array;
    }

    /**
     * Constructs a game and makes the player
     */
    this() {
        this.mainPlayer = new Bunny(this);
        this._totalDifficulty = 15;
        this.otherEntities ~= new Wolf(this, new dVector(0, 0), this._totalDifficulty);
    }

    /**
     * Actually handles running the game
     */
    private void run() {
        this._isRunning = true;
        while (this._isRunning) {
            foreach (entity; this.allEntities) {
                entity.onTick();
            }
            foreach (entity1; this.allEntities) {
                this.allEntities.filter!(entity2 => intersects(entity1.location,
                        entity2.location)).each!(entity2 => entity1.onCollide(entity2));
            }
            foreach (entity; this.allEntities) {
                if (entity.spawnQueue.length > 0) {
                    this.otherEntities = this.otherEntities ~ entity.spawnQueue;
                    entity.spawnQueue = null;
                }
            }
            this.otherEntities = this.otherEntities.filter!(entity => entity.isValid).array;
            this._totalDifficulty += this.difficulty;
            foreach(i; 0 .. this.difficulty) {
                this.otherEntities = this.otherEntities ~ new Wolf(this, new dVector(0, 0), this._totalDifficulty);
            }
            this.difficulty = 0;
            this._isRunning = mainPlayer.isValid;
            Thread.sleep(msecs(1000 / ticksPerSecond));
        }
    }

    /**
     * Sends the game an event; doesn't cause anything to happen, just gives the game a description of what is happening
     * All this method does is add the event to allEvents
     */
    void sendEvent(Event e) {
        this._allEvents ~= e;
    }

    /**
     * Marks the given event as consumed
     */
    void consumeEvent(Event e) {
        this._allEvents.filter!(event => event == e).front.consumed = true;
    }

}
