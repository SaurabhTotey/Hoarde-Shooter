/**
 * Defines the view where the game takes place
 * None of game logic is handled here, just events from user are handled and sent to the actual game engine
 * Actual game logic is in module App
 */
module graphics.views.Main;

import std.algorithm;
import std.conv;
import std.math;
import App;
import graphics.views.components.Image;
import graphics.views.View;

/**
 * The class that is where the user will actually play the game
 * Just handles drawing to the screen and sending events to the appropriate place
 */
class Main: View{

    /**
     * Given the window, makes the main view
     * Adds the image components to itself for ready drawing
     * Doesn't take in a GameState as it utilizes the global GameState object in App
     */
    this(Window window){
        super(window);
    }

    /**
     * Draws the game based on what is happening in GameState
     */
    override void draw(SDL2Renderer renderer){
        this.window.clear(0, 255, 0);
        mainGame.allEntities.each!(entity => new Image(SDL_Rect(entity.hitbox.x, entity.hitbox.y, entity.hitbox.w, entity.hitbox.h), entity.imagePath, this.window.imageCreator, this.window.sdl, entity.hitbox.rotation * 180 / PI).draw(renderer));
        super.draw(renderer);
    }

    /**
     * Takes in keyboard events and then passes the corresponding action to gamestate to use
     * This is how the user actually interacts with the game
     */
    override void handleKey(SDL2Keyboard keyboard){
        if(keyboard.isPressed(SDLK_w)){
            mainGame.adjustPlayerVelocity(0, -1);
        }
        if(keyboard.isPressed(SDLK_s)){
            mainGame.adjustPlayerVelocity(0, 1);
        }
        if(keyboard.isPressed(SDLK_a)){
            mainGame.adjustPlayerVelocity(0.0 - this.window.logicalX / this.window.logicalY, 0);
        }
        if(keyboard.isPressed(SDLK_d)){
            mainGame.adjustPlayerVelocity(0.0 + this.window.logicalX / this.window.logicalY, 0);
        }
        if(keyboard.testAndRelease(SDLK_ESCAPE)){
            mainGame.isRunning = !mainGame.isRunning;
            //TODO handle pause procedure here
        }
        super.handleKey(keyboard);
    }

    /**
     * TODO
     */
    override void handleMouseMovement(SDL2Mouse mouse){
        super.handleMouseMovement(mouse);
    }

    /**
     * TODO
     */
    override void handleMouseClick(ubyte button, SDL2Mouse mouse){
        super.handleMouseClick(button, mouse);
    }

}
