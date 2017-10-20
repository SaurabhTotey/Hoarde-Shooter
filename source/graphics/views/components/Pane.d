module graphics.views.components.Pane;

import graphics.views.components.Component;

class Pane: Component{

    this(SDL_Rect location){
        super(location);
    }

    override void handleKey(SDL_Keysym key){}
    override void handleMouseMovement(SDL2Mouse mouse){}
    override void handleMouseClick(ubyte button, SDL2Mouse mouse){}
    override void handleMouseRelease(ubyte button, SDL2Mouse mouse){}

}
