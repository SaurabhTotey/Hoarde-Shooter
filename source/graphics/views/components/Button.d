/**
 * A module that defines a button component
 */
module graphics.views.components.Button;

import std.datetime;
import graphics.views.components.Pane;

/**
 * A button is a component that has no special appearance, but that defines behaviour for being clicked with the left mouse
 * These buttons don't actually click if the user is "indecisive", and only respond to left clicks
 * Is abstract because the behaviour for the click must be defined in the void action() method
 */
abstract class Button: Pane{

    immutable Duration expectReleaseIn = dur!"msecs"(650);  ///How long the user has to release the left click within the button before the button decides the user hasn't committed to clicking it
    SysTime lastPressed;                                    ///The last time the button was clicked; is used for determining if the user released the click on the button fast enough

    /**
     * Constructs a button as a pane and fulfills the constructor of pane which fulfills the constructor of component
     * Just takes in the button location as an SDL_Rect
     */
    this(SDL_Rect location){
        super(location);
    }

    /**
     * Sets the time of when the button was pressed
     * Doesn't actually call the button's behave method (action) as the user must release the left click button within the specified time within this component
     */
    override void handleMouseClick(ubyte button, SDL2Mouse mouse){
        if(button != SDL_BUTTON_LEFT) return;
        this.lastPressed = Clock.currTime;
    }

    /**
     * Ensures that the user released left click within a fast enough time (to make sure they actually committed and wanted to click here)
     * Then calls the button's behave method (action)
     */
    override void handleMouseRelease(ubyte button, SDL2Mouse mouse){
        if(button != SDL_BUTTON_LEFT || this.lastPressed + this.expectReleaseIn < Clock.currTime) return;
        this.action();
    }

    void action();  ///Any button object must actually have behaviour for what happens when the button is clicked

}
