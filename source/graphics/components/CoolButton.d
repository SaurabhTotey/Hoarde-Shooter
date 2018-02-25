module graphics.components.CoolButton;

import d2d;
import graphics.Constants;

/**
 * A coolbutton is a button that handles all the default expected behaviour and apperances of buttons in hoarde shooter
 * Other than their text and actions, buttons should be the same (as in how they appear)
 */
class CoolButton : Button {

    private Texture text; ///What the button says
    private void delegate() execute; ///What the button will do when clicked

    /**
     * Constructor for a CoolButton
     * Takes in the required display as well as location, text, and action
     */
    this(Display d, iRectangle loc, string text, void delegate() execute) {
        super(d, loc);
        this.text = new Texture(scaled(fonts[Fonts.OpenSans].renderTextBlended(text, PredefinedColor.BLACK), loc.dimensions), d.renderer);
        this.execute = execute;
    }

    /**
     * The button does its action as its action (duh)
     */
    override void action() {
        execute();
    }

    /**
     * Draws the button; button will be different colors based on whether it is hovered or not
     */
    override void draw() {
        this.container.renderer.fillRect(this.location, this.isHovered() ? hoverButtonBg : normalButtonBg);
        this.container.renderer.copy(this.text, this.location);
    }

}