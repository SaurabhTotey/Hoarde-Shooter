module graphics.views.MainMenu;

import d2d;
import graphics.Constants;
import graphics.views.MainGame;
import graphics.views.OptionsMenu;

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
        this.grass = new Texture(images[Images.Grass], this.container.renderer);
        //Defines a component that actually starts the game
        this.components ~= new class Button {

            Texture text;

            this() {
                super(display, new iRectangle(100, 400, 1400, 100));
                this.text = new Texture(fonts[Fonts.OpenSans].renderTextBlended("New Game",
                        PredefinedColor.BLACK), this.container.renderer);
            }

            override void action() {
                this.container.screen = new MainGame(this.container);
            }

            override void draw() {
                this.container.renderer.fillRect(this.location,
                        this.isHovered() ? hoverButtonBg : normalButtonBg);
                this.container.renderer.copy(this.text, new iRectangle(500, 400, 600, 100));
            }
        };
        //Defines a component that opens the config menu
        this.components ~= new class Button {

            Texture text;

            this() {
                super(display, new iRectangle(100, 550, 1400, 100));
                this.text = new Texture(fonts[Fonts.OpenSans].renderTextBlended("Options",
                        PredefinedColor.BLACK), this.container.renderer);
            }

            override void action() {
                this.container.screen = new OptionsMenu(display, this.container.screen);
            }

            override void draw() {
                this.container.renderer.fillRect(this.location,
                        this.isHovered() ? hoverButtonBg : normalButtonBg);
                this.container.renderer.copy(this.text, new iRectangle(600, 550, 400, 100));
            }
        };
        //Defines a component that exits the game
        this.components ~= new class Button {

            Texture text;

            this() {
                super(display, new iRectangle(100, 700, 1400, 100));
                this.text = new Texture(fonts[Fonts.OpenSans].renderTextBlended("Exit",
                        PredefinedColor.BLACK), this.container.renderer);
            }

            override void action() {
                this.container.isRunning = false;
            }

            override void draw() {
                this.container.renderer.fillRect(this.location,
                        this.isHovered() ? hoverButtonBg : normalButtonBg);
                this.container.renderer.copy(this.text, new iRectangle(700, 700, 200, 100));
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
     * The screen just has a tiled grassy background
     */
    override void draw() {
        foreach (i; 0 .. logicalSize.x / 100) {
            foreach (j; 0 .. logicalSize.y / 100) {
                this.container.renderer.copy(this.grass,
                        new iRectangle(100 * i, 100 * j, 100, 100));
            }
        }
    }

}
