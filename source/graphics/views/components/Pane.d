module graphics.views.components.Pane;

public import gfm.sdl2;
import graphics.views.components.Component;

class Pane: Component{

    this(SDL_Rect location){
        super(location);
    }

    override void draw(SDL2Renderer renderer){
        renderer.fillRect(this.location.x, this.location.y, this.location.w, this.location.h);
    }

    override void handleKey(SDL_Keysym key){}
    override void handleMouseMovement(SDL2Mouse mouse){}
    override void handleMouseClick(ubyte button, SDL2Mouse mouse){}
    override void handleMouseRelease(ubyte button, SDL2Mouse mouse){}

}
