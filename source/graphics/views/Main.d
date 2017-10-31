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
import graphics.views.components.Button;
import graphics.views.components.Image;
import graphics.views.components.Label;
import graphics.views.Menu;
import graphics.views.View;

/**
 * The class that is where the user will actually play the game
 * Just handles drawing to the screen and sending events to the appropriate place
 */
class Main: View{

    Component[] pauseScreenComponents;  ///The components that will appear when the game is paused

    /**
     * Given the window, makes the main view
     * Adds the image components to itself for ready drawing
     * Doesn't take in a GameState as it utilizes the global GameState object in App
     */
    this(Window window){
        super(window);
        //Defines pause screen buttons
        this.pauseScreenComponents ~= [
            new class Button{
                this(){
                    super(SDL_Rect((0.1 * window.logicalX).to!int, (0.3 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int));
                }
                override void action(){
                    components = null;
                    mainGame.isRunning = true;
                }
            },
            new class Button{
                this(){
                    super(SDL_Rect((0.1 * window.logicalX).to!int, (0.5 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int));
                }
                override void action(){
                    //TODO open config settings?
                }
            },
            new class Button{
                this(){
                    super(SDL_Rect((0.1 * window.logicalX).to!int, (0.7 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int));
                }
                override void action(){
                    window.currentScreen = new Menu(window);
                    //TODO quit better
                }
            }
        ];
        //Labels the pause screen buttons
        string[] buttonLabels = ["Resume", "Config", "Exit Game"];
        foreach(i; 0..3){
            pauseScreenComponents ~= pauseScreenComponents[i].makeTextOverlay(buttonLabels[i], Font(Calligraphy.OpenSans, this.window.ttf));
        }
    }

    /**
     * Draws the game based on what is happening in GameState
     */
    override void draw(SDL2Renderer renderer){
        this.window.clear(0, 255, 0);
        mainGame.allEntities.each!(entity => new Image(SDL_Rect(entity.hitbox.x.to!int, entity.hitbox.y.to!int, entity.hitbox.w.to!int, entity.hitbox.h.to!int), entity.imagePath, this.window.imageCreator, this.window.sdl, entity.hitbox.rotation * 180 / PI).draw(renderer));
        renderer.setColor(150, 150, 150);
        super.draw(renderer);
    }

    /**
     * Takes in keyboard events and then passes the corresponding action to gamestate to use
     * This is how the user actually interacts with the game
     */
    override void handleKey(SDL2Keyboard keyboard){
        if(mainGame.isRunning){
            double scaling = 5.0;
            if(keyboard.isPressed(SDLK_w)){
                mainGame.adjustPlayerVelocity(0, -scaling);
            }
            if(keyboard.isPressed(SDLK_s)){
                mainGame.adjustPlayerVelocity(0, scaling);
            }
            if(keyboard.isPressed(SDLK_a)){
                mainGame.adjustPlayerVelocity(-scaling * this.window.logicalX / this.window.logicalY, 0);
            }
            if(keyboard.isPressed(SDLK_d)){
                mainGame.adjustPlayerVelocity(scaling * this.window.logicalX / this.window.logicalY, 0);
            }
        }
        if(keyboard.testAndRelease(SDLK_ESCAPE)){
            mainGame.isRunning = !mainGame.isRunning;
            this.components = (mainGame.isRunning)? null : this.pauseScreenComponents;
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
