/**
 * Entry point for the game
 * Where all the important objects and data are held
 * Also where the engine runs the game logic
 */
module App;

import std.algorithm;
import std.array;
import std.conv;
import std.datetime;
import std.math;
import core.thread;
import graphics.Window;
import objects.Bullet;
import objects.Bunny;
import objects.Entity;
import objects.Wolf;

/**
 * A storage class for the data of the game
 * Holds all game data and is mutable
 * Game logic uses a GameState and updates it
 * The graphics implementation draws the game based on the data in GameState
 */
class GameState{

    immutable int ticksPerSecond = 20;  ///How many times per second the game logic will update all objects
    __gshared Entity[] allEntities;     ///All objects that exist within the world
    __gshared bool isRunning;           ///Whether the game logic is running or not
    long numTicks;                      ///How many gameticks have passed in the game
    immutable int worldX;               ///The world width
    immutable int worldY;               ///The world height

    /**
     * Gets the player entity from the list of allEntities
     * The player entity should always be the first item in allEntities
     * Is functionally useless but just a shortcut for clearer code that is faster to type
     */
    @property Entity player(){
        return this.allEntities[0];
    }

    /**
     * Makes a game with the given world width and height
     * Also initializes all basic game objects
     */
    this(immutable int worldX, immutable int worldY){
        this.worldX = worldX;
        this.worldY = worldY;
        this.allEntities ~= new Bunny(Rectangle(worldX / 2, worldY / 2, 100, 100));
    }

    /**
     * Destroys all contained game entities once the game is over
     */
    ~this(){
        this.allEntities.destroy();
    }

    /**
     * Runs the game logic
     * Ensures that the timing and updating of game logic happens at the correct speed as defined by ticksPerSecond
     */
    void run(){
        this.isRunning = true;
        SysTime lastTickTime;
        while(mainWindow.isRunning && mainGame !is null){
            while(this.isRunning){
                if(!mainWindow.isRunning) break;
                //Caps the tick rate to the ticksPerSecond field by only executing actions at the rate specified by ticksPerSecond
                if(Clock.currTime >= lastTickTime + dur!"msecs"((1000.0 / this.ticksPerSecond).to!int)){
                    lastTickTime = Clock.currTime;
                    //Performs the tick action for every entity
                    this.allEntities.each!(entity => entity.tickAction());
                    //Handles all entity collisions TODO this is a very naive implementation that is extremely inefficient
                    foreach(entity; this.allEntities){
                        this.allEntities.filter!(other => other != entity && entity.hitbox.intersects(other.hitbox)).each!(collidedWith => entity.onCollide(collidedWith));
                    }
                    //Removes all entities that are dead
                    this.allEntities = this.allEntities.filter!(entity => entity.health > 0).array;

                    //TODO below is temporary
                    if(this.allEntities.length == 1){
                        import std.random;
                        this.allEntities ~= new Wolf(Rectangle(uniform(150, worldX - 150), uniform(150, worldY - 150), 150, 150, -PI / 2));
                    }
                    //TODO above is temporary

                    this.numTicks++;
                }
            }
        }
        this.isRunning = false;
    }

    /**
     * Returns whether a rectangle is out of bounds
     */
    bool isOutOfBounds(Rectangle hitbox){
        return hitbox.x + hitbox.w / 2 < 0 || hitbox.x - hitbox.w / 2 > this.worldX || hitbox.y + hitbox.h / 2 < 0 || hitbox.y - hitbox.h / 2 > this.worldY;
    }

    /**
     * Adjusts the player's rotation such that they are facing towards the point
     * Doesn't change affect their velocity
     * Can be called on from other threads (most notably, the graphics thread)
     */
    __gshared void adjustPlayerRotation(int towardsX, int towardsY){
        this.player.hitbox.rotation = atan2(towardsY - this.player.hitbox.y, towardsX - this.player.hitbox.x);
    }

    /**
     * Adjusts the player's velocity by the given x and y amounts
     * Can be called on from other threads (most notably, the graphics thread)
     */
    __gshared void adjustPlayerVelocity(double xChange, double yChange){
        this.player.componentVelocities.x += xChange;
        this.player.componentVelocities.y += yChange;
    }

    /**
     * Shoots a bullet from the player's location towards the given point
     * Can be called on from other threads (most notably, the graphics thread)
     */
    __gshared void shootBulletTowards(int towardsX, int towardsY){
        double playerX = this.player.hitbox.x;
        double playerY = this.player.hitbox.y;
        this.allEntities ~= new Bullet(playerX.to!int, playerY.to!int, atan2(towardsY - playerY, towardsX - playerX), this.player);
    }

}

__gshared Window mainWindow;    ///The main window for the game; runs on a separate thread and only handles graphics
__gshared GameState mainGame;   ///The actual game data; logic runs based on this, and the window draws based on this as well

/**
 * Entry point for the game
 * Creates a window and waits for the window to either select a game or construct a new game
 * Runs all of the game logic
 */
void main(){
    //Creates and starts a new thread for all graphics processes
    new Thread({
        //Makes a new window inside of this thread, but stores it in the global __gshared mainWindow variable so data is accessible everywhere
        mainWindow = new Window("Hoarde Shooter", "res/images/DisgustingBunny.png");
        //Defines that as soon as the thread stops running and the scope is left, the mainWindow is to be destroyed
        scope(exit){
            mainWindow.destroy();
        }
        //Runs the window so that it actually starts working; method runs until window is closed; once method is done, thread stops and scope is left
        mainWindow.run();
    }).start();
    //Waits for the game and window to exist and then runs the game
    while(!mainWindow.isRunning){}
    while(mainWindow.isRunning){
        if(mainGame !is null){
            mainGame.run();
        }
    }
}
