module graphics.views.Options;

import std.conv;
import graphics.views.components.Button;
import graphics.views.components.Label;
import graphics.views.View;

class Options(T: View): View{

    this(Window window){
        super(window);
        this.components ~= new Label(SDL_Rect(0, 0, window.logicalX, (window.logicalY * 0.8).to!int), "THIS SCREEN IS INCOMPLETE", Font(Calligraphy.OpenSans, window.ttf));
        this.components ~= new class Button{
            this(){
                super(SDL_Rect(0, (window.logicalY * 0.8).to!int, window.logicalX, (window.logicalY * 0.1).to!int), SDL_Color(150, 150, 150));
            }
            override void action(){
                window.currentScreen = new T(window);
            }
        };
        this.components ~= this.components[1].makeTextOverlay("OH GOD, GO BACK!", Font(Calligraphy.OpenSans, this.window.ttf));
    }

    override void draw(SDL2Renderer renderer){
        this.window.clear(0, 255, 0);
        super.draw(renderer);
    }

}
