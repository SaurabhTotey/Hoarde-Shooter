module graphics.views.Menu;

import graphics.views.components.Button;
import graphics.views.View;

class Menu: View{

    this(Window window){
        super(window);
        this.components ~= new class Button{
            this(){super(SDL_Rect(20, 240, 600, 50));}
            override void action(){
                import std.stdio;
                writeln("Button clicked.");
            }
        };
    }

    override void draw(SDL2Renderer renderer){
        super.draw(renderer);
    }

};
