module Main;

import core.thread;
import graphics.Window;

class GameState{

}

__gshared Window mainWindow;
__gshared GameState mainGame;

void main(){
    new Thread({
        mainWindow = new Window();
        scope(exit){
            mainWindow.destroy();
        }
        mainWindow.run();
    }).start();
}
