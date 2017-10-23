/**
 * The starting view of the game
 * Is the main menu
 */
module graphics.views.Menu;

import std.conv;
import graphics.views.components.Button;
import graphics.views.components.Label;
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
        int amtPressed;
        this.components ~= new class Button{
            this(){
                super(SDL_Rect((0.1 * window.logicalX).to!int, (0.5 * window.logicalY).to!int, (0.8 * window.logicalX).to!int, (0.1 * window.logicalY).to!int));
            }
            override void action(){
                import std.stdio;
                writeln("Button clicked: ", amtPressed);
                amtPressed++;
            }
        };
        this.components ~= this.components[0].makeTextOverlay("This is a button", Font(Calligraphy.OpenSans, this.window.ttf));
    }

    /**
     * How the menu should be rendered
     * Takes in the SDL2Renderer
     * Menu views don't do much of anything special for how they appear other than showing their components
     */
    override void draw(SDL2Renderer renderer){
        renderer.setViewportFull();
        this.window.clear(0, 255, 0);
        renderer.setColor(150, 150, 150);
        super.draw(renderer);
    }

};
