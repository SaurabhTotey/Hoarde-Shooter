module graphics.views.components.Component;

public import gfm.sdl2;

abstract class Component{

    SDL_Rect location;

    this(SDL_Rect location){
        this.location = location;
    }

    void draw(SDL2Renderer renderer){
        renderer.drawRect(this.location.x, this.location.y, this.location.w, this.location.h);
    }

    void handleKey(SDL_Keysym key);
    void handleMouseMovement(SDL2Mouse mouse);
    void handleMouseClick(ubyte button, SDL2Mouse mouse);
    void handleMouseRelease(ubyte button, SDL2Mouse mouse);

}
