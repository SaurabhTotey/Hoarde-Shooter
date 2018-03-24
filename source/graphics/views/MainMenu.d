module graphics.views.MainMenu;

import d2d;
import graphics.components.CoolButton;
import graphics.Constants;
import graphics.views.MainGame;
import graphics.views.OptionsMenu;

/**
 * The main menu screen
 * Just a hub to go to other screens
 */
class MainMenu : Activity {

    Texture grass; //Defines the grass texture that is just the background

    /**
     * Required constructor to pass in display
     */
    this(Display display) {
        super(display);
        this.grass = new Texture(images[Images.Grass], this.container.renderer);
        //Defines a component that actually starts the game
        this.components ~= new CoolButton(display, new iRectangle(100, 400, 1400, 100), "New Game", {
            this.container.activity = new MainGame(this.container);
        });
        //Defines a component that opens the config menu
        this.components ~= new CoolButton(display, new iRectangle(100, 550, 1400, 100), "Options", {
            this.container.activity = new OptionsMenu(display, this.container.activity);
        });
        //Defines a component that exits the game
        this.components ~= new CoolButton(display, new iRectangle(100, 700, 1400, 100), "Exit", {
            this.container.isRunning = false;
        });
    }

    /**
     * This screen on its own doesn't do anything to respond to events
     */
    override void handleEvent(SDL_Event event) {
    }

    /**
     * This screen on its own doesn't do anything special in between frames
     */
    override void update() {
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
