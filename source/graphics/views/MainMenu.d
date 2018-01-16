module graphics.views.MainMenu;

import d2d;
import graphics.Constants;

/**
 * The main menu screen
 * Just a hub to go to other screens
 */
class MainMenu : Screen {

    /**
     * Required constructor to pass in display
     */
    this(Display container) {
        super(container);
    }

    /**
     * This screen on its own doesn't do anything to respond to events
     */
    void handleEvent(SDL_Event event) {
    }

    /**
     * This screen on its own doesn't do anything special in between frames
     */
    override void onFrame() {
    }

    /**
     * The screen just has a green background
     */
    override void draw() {
        this.container.window.renderer.fillRect(new iRectangle(0, 0,
                logicalSize.x, logicalSize.y), PredefinedColor.GREEN);
    }

}
