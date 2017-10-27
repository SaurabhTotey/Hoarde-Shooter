/**
 * Entry point for the game
 * Where all the important objects and data are held
 * Also where the engine runs the game logic
 */
module App;

import std.typecons;
import core.thread;
import graphics.Window;

/**
 * A storage class for the data of the game
 * Holds all game data and is mutable
 * Game logic uses a GameState and updates it
 * The graphics implementation draws the game based on the data in GameState
 */
class GameState{

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
}
