module graphics.views.Menu;

import graphics.views.components.Button;
import graphics.views.components.Text;
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
        this.components ~= new Text(SDL_Point(20, 240), "This is a button", window.defaultFont);
    }

    override void draw(SDL2Renderer renderer){
        renderer.setViewportFull();
        renderer.setColor(0, 255, 0);
        renderer.clear();
        renderer.setColor(150, 150, 150);
        super.draw(renderer);
    }

};
