/**
 * A module that defines a button component
 */
module graphics.views.components.Button;

import std.datetime;
import core.thread;
import graphics.views.components.Pane;

/**
 * A button is a component that has no special appearance, but that defines behaviour for being clicked with the left mouse
 * These buttons don't actually click if the user is "indecisive", and only respond to left clicks
 * Is abstract because the behaviour for the click must be defined in the void action() method
 */
abstract class Button: Pane{

    immutable Duration expectReleaseIn = dur!"msecs"(650);  ///How long the user has to release the left click within the button before the button decides the user hasn't committed to clicking it
    SysTime lastPressed;                                    ///The last time the button was clicked; is used for determining if the user released the click on the button fast enough
    __gshared SDL_Color regularColor;                       ///The color the button normally is until it is moused over
    __gshared SDL_Color highlightColor;                     ///The color the button turns when it is moused over

    /**
     * Constructs a button as a pane and fulfills the constructor of pane which fulfills the constructor of component
     * Takes in the button location as an SDL_Rect and a button color that it will usually be, and a highlight color for it to be when moused over
     * Default highlight color is light blue
     */
    this(SDL_Rect location, SDL_Color regularColor, SDL_Color highlightColor = SDL_Color(173, 216, 230)){
        super(location, regularColor);
        this.regularColor = regularColor;
        this.highlightColor = highlightColor;
    }

    /**
     * What the button does when moused over
     * It just changes color until the mouse leaves it
     */
    override void handleMouseMovement(SDL2Mouse mouse){
        this.color = (this.location.contains(mouse.position))? highlightColor : regularColor;
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
