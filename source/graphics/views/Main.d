/**
 * Defines the view where the game takes place
 * None of game logic is handled here, just events from user are handled and sent to the actual game engine
 * Actual game logic is in module App
 */
module graphics.views.Main;

import std.algorithm;
import std.conv;
import std.math;
import std.typecons;
import gfm.math;
import App;
import graphics.Sound;
import graphics.views.components.Button;
import graphics.views.components.Image;
import graphics.views.components.Label;
import graphics.views.Menu;
import graphics.views.Options;
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
        //Ensures that the spinning song isn't playing and then makes the window start playing it
        bool shouldMusicPlay = true;
        foreach(sound; window.allSounds){
            if(sound.id == Music.SpinningSong.to!string){
                shouldMusicPlay = false;
                break;
            }
        }
        if(shouldMusicPlay) window.allSounds ~= new Sound!Music(Music.SpinningSong, window.mixer, -1);
        //Makes the screen background grass; couldn't make tiled background because rendering it took too long with current architecture
        this.components ~= new Image(SDL_Rect(0, 0, window.logicalX, window.logicalY), "res/images/Grass.png", window.imageCreator, window.sdl);
        //Defines pause screen buttons
        this.pauseScreenComponents ~= [
            new class Button{
                this(){
                    super(SDL_Rect((0.1 * window.logicalX).to!int, (0.3 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int), SDL_Color(150, 150, 150));
                }
                override void action(){
                    components = components[0..$-pauseScreenComponents.length];
                    mainGame.isRunning = true;
                }
            },
            new class Button{
                this(){
                    super(SDL_Rect((0.1 * window.logicalX).to!int, (0.5 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int), SDL_Color(150, 150, 150));
                }
                override void action(){
                    window.currentScreen = new Options(window, new Main(window));
                }
            },
            new class Button{
                this(){
                    super(SDL_Rect((0.1 * window.logicalX).to!int, (0.7 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int), SDL_Color(150, 150, 150));
                }
                override void action(){
                    mainGame.destroy();
                    mainGame = null;
                    window.currentScreen = new Menu(window);
                }
            }
        ];
        //Labels the pause screen buttons
        string[] buttonLabels = ["Resume", "Options", "Exit Game"];
        foreach(i; 0..3){
            pauseScreenComponents ~= pauseScreenComponents[i].makeTextOverlay(buttonLabels[i], Font(Calligraphy.OpenSans, window.ttf));
        }
        //If the main screen is constructed while the game is paused, it adds the pauseScreenComponents to the list of components
        if(!mainGame.isRunning){
            this.components ~= pauseScreenComponents;
        }
    }

    /**
     * Draws the game based on what is happening in GameState
     */
    override void draw(SDL2Renderer renderer){
        this.window.clear(0, 255, 0);
        if(mainGame.isRunning){
            mainGame.adjustPlayerRotation(this.window.sdl.mouse.x, this.window.sdl.mouse.y);
        }
        this.components[0].draw(renderer);
        mainGame.allEntities.each!(entity => scoped!Image(SDL_Rect((entity.hitbox.x - entity.hitbox.w / 2).to!int, (entity.hitbox.y - entity.hitbox.h / 2).to!int, entity.hitbox.w.to!int, entity.hitbox.h.to!int), entity.imagePath, this.window.imageCreator, this.window.sdl, entity.hitbox.rotation.degrees + 90).draw(renderer));
        foreach(i; 1..this.components.length){
            this.components[i].draw(renderer);
        }
    }

    /**
     * Releases all of the resources of the main screen by deleting components and pause screen components
     */
    ~this(){
        foreach(component; this.pauseScreenComponents){
            component.destroy();
        }
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
            this.components = (mainGame.isRunning)? this.components[0..$-this.pauseScreenComponents.length] : this.components ~ this.pauseScreenComponents;
        }
        super.handleKey(keyboard);
    }

    /**
     * Handles a mouse click by making the bunny shoot a bullet
     * Only does that behaviour if the game isn't paused and the clicked mouse button was a left click
     */
    override void handleMouseClick(ubyte button, SDL2Mouse mouse){
        if(mainGame.isRunning && button == SDL_BUTTON_LEFT){
            mainGame.shootBulletTowards(mouse.x, mouse.y);
        }
        super.handleMouseClick(button, mouse);
    }

}
