/**
 * Entry point for the game
 * Where all the important objects and data are held
 * Also where the engine runs the game logic
 */
module App;

import std.algorithm;
import std.conv;
import std.datetime;
import core.thread;
import graphics.Window;
import objects.Bunny;
import objects.Entity;

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
    immutable int worldX;               ///The world width
    immutable int worldY;               ///The world height

    /**
     * Makes a game with the given world width and height
     * Also initializes all basic game objects
     */
    this(immutable int worldX, immutable int worldY){
        this.worldX = worldX;
        this.worldY = worldY;
        this.allEntities ~= new Bunny(Rectangle(worldX / 2 - 100 / 2, worldY / 2 - 100 / 2, 100, 100));
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
                if(Clock.currTime >= lastTickTime + dur!"msecs"((1000.0 / this.ticksPerSecond).to!int)){
                    lastTickTime = Clock.currTime;
                    this.allEntities.each!(entity => entity.tickAction());
                    if(!mainWindow.isRunning) break;
                }
            }
        }
        this.isRunning = false;
    }

    /**
     * Adjusts the player's velocity by the given x and y amounts
     * Can be called on other threads (most notably, the graphics thread)
     */
    __gshared void adjustPlayerVelocity(double xChange, double yChange){
        this.allEntities[0].componentVelocities.x += xChange;
        this.allEntities[0].componentVelocities.y += yChange;
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
        mainWindow = new Window("Hoarde Shooter");
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
