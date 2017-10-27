/**
 * A module to define a component or a widget that takes up a physical space within a view
 * Components have behaviours and layouts defined within a physical space
 * Components are contained by views which are contained by windows
 */
module graphics.views.components.Component;

public import gfm.sdl2;
import graphics.views.components.Label;

/**
 * A component class is a class which represents an object that takes a physical space (in the form of a rectangle) on the screen
 * Is contained by a view and within the space it takes up, it defines its appearance and behaviour
 */
abstract class Component{

    SDL_Rect location;      ///The location of the component; all components are rectangular, but don't need to be drawn as such

    alias location this;    ///Allows the component to be accessed as if it were its rectangle of location

    /**
     * Constructs a component with a location
     * All components must have locations as they are inherently something that take up space
     */
    this(SDL_Rect location){
        this.location = location;
    }

    void draw(SDL2Renderer renderer);                       ///Components must define their appearance in the draw method
    void handleKey(SDL_Keysym key);                         ///Components must define their behaviour for keypresses
    void handleMouseMovement(SDL2Mouse mouse);              ///Components must define their behaviour for mouse movements
    void handleMouseClick(ubyte button, SDL2Mouse mouse);   ///Components must define their behaviour for mouse click
    void handleMouseRelease(ubyte button, SDL2Mouse mouse); ///Components must define their behaviour for mouse click releases

}

/**
 * SDL_PointInRect doesn't work until SDL2.0.4
 * Returns whether a point is within the bounds of a rectangle
 */
bool contains(SDL_Rect rectangle, SDL_Point point){
    return point.x >= rectangle.x && point.x <= rectangle.x + rectangle.w && point.y >= rectangle.y && point.y <= rectangle.y + rectangle.h;
}

/**
 * Returns a label which goes over a base component with the given base component, text, font, and optional color
 * The component returned by this method must be added to the view, as simply creating this component doesn't do anything
 */
Component makeTextOverlay(Component baseComponent, string textToOverlay, Font textFont, SDL_Color textColor = SDL_Color(0, 0, 0, 255)){
    return new Label(baseComponent.location, textToOverlay, textFont, textColor);
}

/**
 * Returns an image which goes over a base component with the given base component and path to image
 * The component returned by this method must be added to the view, as simply creating this component doesn't do anything
 */
Component makeImageOverlay(Component baseComponent, string pathToImage){
    return null; //TODO implement this method
}
