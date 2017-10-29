/**
 * Defines the view where the game takes place
 * None of game logic is handled here, just events from user are handled and sent to the actual game engine
 * Actual game logic is in module App
 */
module graphics.views.Main;

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

    Image bunny;    ///The image of the DisgustingBunny that is displayed in this view TODO is temporary variable for a few commits

    /**
     * Given the window, makes the main view
     * Adds the image components to itself for ready drawing
     * Doesn't take in a GameState as it utilizes the global GameState object in App
     */
    this(Window window){
        super(window);
        this.bunny = new Image(SDL_Rect(750, 400, 100, 100), "res/images/DisgustingBunny.png", this.window.imageCreator, this.window.sdl);
        this.components ~= this.bunny;
    }

    /**
     * Draws the game based on what is happening in GameState
     */
    override void draw(SDL2Renderer renderer){
        this.window.clear(0, 255, 0);
        super.draw(renderer);
    }

    /**
     * Takes in keyboard events and then passes the corresponding action to gamestate to use
     * This is how the user actually interacts with the game
     */
    override void handleKey(SDL2Keyboard keyboard){
        if(keyboard.isPressed(SDLK_w)){
            this.bunny.location.y -= 4;
        }
        if(keyboard.isPressed(SDLK_s)){
            this.bunny.location.y += 4;
        }
        if(keyboard.isPressed(SDLK_a)){
            this.bunny.location.x -= 4;
        }
        if(keyboard.isPressed(SDLK_d)){
            this.bunny.location.x += 4;
        }
        this.angleBunny();
    }

    /**
     * Handles mouse movement by taking the mouse coordinates and adjusting rotation of bunny based off of that
     */
    override void handleMouseMovement(SDL2Mouse mouse){
        this.angleBunny();
        super.handleMouseMovement(mouse);
    }

    /**
     * Function to angle the bunny towards the mouse
     * TODO is temporary variable for a few commits
     */
    void angleBunny(){
        SDL_Point mouseLocation = this.window.sdl.mouse.position;
        SDL_Point bunnyLocation = SDL_Point(this.bunny.location.x + this.bunny.location.w / 2, this.bunny.location.y + this.bunny.location.h / 2);
        this.bunny.rotation = atan2(0.0 + mouseLocation.y - bunnyLocation.y, 0.0 + mouseLocation.x - bunnyLocation.x) * 180 / PI;
    }

}
