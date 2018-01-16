module graphics.views.MainMenu;

import d2d;
import graphics.Constants;
import graphics.views.MainGame;

/**
 * The main menu screen
 * Just a hub to go to other screens
 */
class MainMenu : Screen {

    Texture grass; //Defines the grass texture that is just the background

    /**
     * Required constructor to pass in display
     */
    this(Display display) {
        super(display);
        this.grass = new Texture(images[Images.Grass], this.container.window.renderer);
        //Defines a component that actually starts the game
        this.components ~= new class Button {

            Texture text;
            Color normalBg = PredefinedColor.LIGHTGREY;
            Color hoverBg = PredefinedColor.GREEN;

            this() {
                super(display, new iRectangle(100, 400, 1400, 100));
                this.text = new Texture(fonts[Fonts.OpenSans].renderTextBlended("New Game",
                        PredefinedColor.BLACK), this.container.window.renderer);
            }

            override void action() {
                this.container.screen = new MainGame(this.container);
            }

            override void draw() {
                this.container.window.renderer.fillRect(this.location,
                        this.isHovered ? this.hoverBg : this.normalBg);
                this.container.window.renderer.copy(this.text, this.location);
            }
        };
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
        this.container.window.renderer.copy(this.grass, new iRectangle(0, 0,
                logicalSize.x, logicalSize.y));
    }

}
