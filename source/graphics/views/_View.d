module graphics.views.View;

public import gfm.sdl2;
public import graphics.Window;

abstract class View{

    Window window;

    this(Window window){
        this.window = window;
    }

    void draw(SDL2Renderer renderer);
    void handleKey(SDL_Keysym key);
    void handleMouseMovement(SDL2Mouse mouse);
    void handleMouseClick(ubyte button, SDL2Mouse mouse);
    void handleMouseRelease(ubyte button, SDL2Mouse mouse);

}
