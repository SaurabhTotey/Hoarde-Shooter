module graphics.views.View;

import std.algorithm;
public import gfm.sdl2;
public import graphics.views.components.Component;
public import graphics.Window;

abstract class View{

    Window window;
    Component[] components;
    Component focusedComponent;

    this(Window window){
        this.window = window;
    }

    abstract void draw(SDL2Renderer renderer){
        //TODO make it so that the components don't need to define pixel locations for their rectangles, but instead they define standardized coordinates
        this.components.each!(component => component.draw(renderer));
    }

    void handleKey(SDL_Keysym key){
        if(this.focusedComponent !is null) this.focusedComponent.handleKey(key);
    }

    void handleMouseMovement(SDL2Mouse mouse){
        SDL_Point currentPosition = mouse.position;
        SDL_Point previousPosition = mouse.previousPosition;
        foreach(x; previousPosition.x .. currentPosition.x){
            foreach(y; previousPosition.y .. currentPosition.y){
                this.components.filter!(component => component.contains(SDL_Point(x, y))).each!(component => component.handleMouseMovement(mouse));
            }
        }
    }

    void handleMouseClick(ubyte button, SDL2Mouse mouse){
        this.components.filter!(component => component.contains(mouse.position)).each!(component => component.handleMouseClick(button, mouse));
    }

    void handleMouseRelease(ubyte button, SDL2Mouse mouse){
        this.components.filter!(component => component.contains(mouse.position)).each!(component => component.handleMouseRelease(button, mouse));
    }

}
