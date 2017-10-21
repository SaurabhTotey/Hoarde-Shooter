module graphics.views.components.Component;

public import gfm.sdl2;

abstract class Component{

    SDL_Rect location;

    alias location this;

    this(SDL_Rect location){
        this.location = location;
    }

    void draw(SDL2Renderer renderer);
    void handleKey(SDL_Keysym key);
    void handleMouseMovement(SDL2Mouse mouse);
    void handleMouseClick(ubyte button, SDL2Mouse mouse);
    void handleMouseRelease(ubyte button, SDL2Mouse mouse);

}

/**
 * SDL_PointInRect doesn't work until SDL2.0.4
 */
bool contains(SDL_Rect rectangle, SDL_Point point){
    return point.x >= rectangle.x && point.x <= rectangle.x + rectangle.w && point.y >= rectangle.y && point.y <= rectangle.y + rectangle.h;
}
