/**
 * A module containing panes: possibly one of the most basic component implementations
 */
module graphics.views.components.Pane;

public import gfm.sdl2;
import graphics.views.components.Component;

/**
 * A very basic implementation of a component
 * Doesn't do anything with events, just defines it drawing as a filled rectangle
 */
class Pane: Component{

    /**
     * A constructor for pane is the same as a constructor for any component
     * Takes in the location as an SDL_Rect
     */
    this(SDL_Rect location){
        super(location);
    }

    /**
     * Draws the component as a filled rectangle
     */
    override void draw(SDL2Renderer renderer){
        renderer.fillRect(this.location.x, this.location.y, this.location.w, this.location.h);
    }

    override void handleKey(SDL2Keyboard keyboard){}                    ///No key handling
    override void handleMouseMovement(SDL2Mouse mouse){}                ///No mouse movement handling
    override void handleMouseClick(ubyte button, SDL2Mouse mouse){}     ///No mouse click handling
    override void handleMouseRelease(ubyte button, SDL2Mouse mouse){}   ///No mouse click release handling

}
