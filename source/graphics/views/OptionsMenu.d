module graphics.views.OptionsMenu;

import d2d;
import graphics.components.CoolButton;
import graphics.Constants;

/**
 * The options menu where the user can change settings
 */
class OptionsMenu : Screen {

    /**
     * Creates an OptionsMenu and sets all the buttons
     */
    this(Display display, Screen previousScreen) {
        super(display);
        this.components ~= new CoolButton(display, new iRectangle(100, 700, 1400, 100), "YAY", {
            this.container.screen = previousScreen;
        });
    }

    /**
     * Options menus don't do anything special with events
     */
    void handleEvent(SDL_Event event) {
    }

    /**
     * Options menus don't do anything special every frame
     */
    override void onFrame() {
    }

    /**
     * Options menus don't do anything special in terms of graphics
     */
    override void draw() {
    }

}
