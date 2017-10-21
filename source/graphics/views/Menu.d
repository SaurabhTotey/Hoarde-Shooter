module graphics.views.Menu;

import graphics.views.components.Button;
import graphics.views.components.Label;
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
        this.components ~= new Label(SDL_Rect(20, 240, 600, 50), "This is a button", Font(Calligraphy.OpenSans, this.window.ttf));
    }

    override void draw(SDL2Renderer renderer){
        renderer.setViewportFull();
        renderer.setColor(0, 255, 0);
        renderer.clear();
        renderer.setColor(150, 150, 150);
        super.draw(renderer);
    }

};
