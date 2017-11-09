/**
 * The starting view of the game
 * Is the main menu
 */
module graphics.views.Menu;

import std.conv;
import App;
import graphics.views.components.Button;
import graphics.views.components.Label;
import graphics.views.Main;
import graphics.views.Options;
import graphics.views.View;

/**
 * A menu view
 * Is the first part of the game
 * Just a launching point into other views
 */
class Menu: View{

    /**
     * Constructor for a menu view
     * Takes in the window and initializes and adds the necessary components (eg. buttons) to itself
     */
    this(Window window){
        super(window);
        //Adds a new game button in the center of the screen
        this.components ~= new class Button{
            this(){
                super(SDL_Rect((0.1 * window.logicalX).to!int, (0.4 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int), SDL_Color(150, 150, 150));
            }
            override void action(){
                mainGame = new GameState(window.logicalX, window.logicalY);
                window.currentScreen = new Main(window);
            }
        };
        this.components ~= this.components[0].makeTextOverlay("New Game", Font(Calligraphy.OpenSans, window.ttf));
        //Adds an options button
        this.components ~= new class Button{
            this(){
                super(SDL_Rect((0.1 * window.logicalX).to!int, (0.6 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int), SDL_Color(150, 150, 150));
            }
            override void action(){
                window.currentScreen = new Options(window, new Menu(window));
            }
        };
        this.components ~= this.components[2].makeTextOverlay("Options", Font(Calligraphy.OpenSans, window.ttf));
        //Adds a quit button in the bottom of the screen
        this.components ~= new class Button{
            this(){
                super(SDL_Rect((0.1 * window.logicalX).to!int, (0.8 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int), SDL_Color(150, 150, 150));
            }
            override void action(){
                window.isRunning = false;
            }
        };
        this.components ~= this.components[4].makeTextOverlay("Exit", Font(Calligraphy.OpenSans, window.ttf));
        //Adds the title to the top
        this.components ~= new Label(SDL_Rect((0.1 * window.logicalX).to!int, 0, (0.8 * window.logicalX).to!int, (0.4 * window.logicalY).to!int), "Hoarde Shooter!", Font(Calligraphy.SpecialElite, window.ttf));
    }

    /**
     * How the menu should be rendered
     * Takes in the SDL2Renderer
     * Menu views don't do much of anything special for how they appear other than showing their components
     */
    override void draw(SDL2Renderer renderer){
        renderer.setViewportFull();
        this.window.clear(0, 255, 0);
        renderer.setColor(250, 250, 250);
        super.draw(renderer);
    }

};
