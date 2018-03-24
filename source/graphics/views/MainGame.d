module graphics.views.MainGame;

import core.thread;
import d2d;
import graphics.components.CoolButton;
import graphics.Constants;
import graphics.views.MainMenu;
import graphics.views.OptionsMenu;
import logic.Bunny;
import logic.game;

/**
 * The screen where the actual game is played; stores the game and all of its resources
 */
class MainGame : Activity {

    Game game; ///The actual game object that handles logic and flow
    Thread gameRunner; ///The thread that actually runs the game
    Texture[Images] textures; ///The textures used by the game
    Sound!(SoundType.Music) spinningSong; ///The game's background music
    ComponentGroup pauseMenu; ///The components for the game's pause menu

    /**
     * Makes a MainGame screen that creates the screen's game and loads all textures and sounds
     */
    this(Display display) {
        super(display);
        this.game = new Game();
        foreach (image, surface; images) {
            this.textures[image] = new Texture(surface, this.container.renderer);
        }
        this.spinningSong = new Sound!(SoundType.Music)("res/sounds/music/SpinningSong.wav");
        this.pauseMenu = new ComponentGroup(this.container, [
            new CoolButton(display, new iRectangle(100, 200, 1400, 100), "Resume", {togglePause();}),
            new CoolButton(display, new iRectangle(100, 400, 1400, 100), "Options", {
                this.container.activity = new OptionsMenu(display, this.container.activity);
            }),
            new CoolButton(display, new iRectangle(100, 600, 1400, 100), "Exit", {
                this.container.activity = new MainMenu(this.container);
            })
        ]);
        this.gameRunner = new Thread({ this.game.isRunning = true; });
        this.gameRunner.start();
    }

    /**
     * Handles toggling game pause procedure
     */
    void togglePause() {
        if (this.game.isRunning) {
            this.game.isRunning = false;
            pause!(SoundType.Music);
            this.components ~= this.pauseMenu;
        }
        else {
            this.components = null;
            this.gameRunner.start();
            resume!(SoundType.Music);
        }
    }

    /**
     * Handles collecting events to send to the game object logic controller
     */
    override void handleEvent(SDL_Event event) {
        if (event.type == SDL_QUIT) {
            this.game.isRunning = false;
        }
        if (this.container.keyboard.allKeys[SDLK_ESCAPE].testAndRelease()) {
            this.togglePause();
        }
    }

    /**
     * Because this method gets called periodically and uniformly, sends input data to game in uniform rate
     */
    override void update() {
        if (!this.game.isRunning) {
            return;
        }
        if (this.container.keyboard.allKeys[SDLK_w].isPressed()) {
            this.game.mainPlayer.move(Direction.UP);
        }
        if (this.container.keyboard.allKeys[SDLK_a].isPressed()) {
            this.game.mainPlayer.move(Direction.LEFT);
        }
        if (this.container.keyboard.allKeys[SDLK_s].isPressed()) {
            this.game.mainPlayer.move(Direction.DOWN);
        }
        if (this.container.keyboard.allKeys[SDLK_d].isPressed()) {
            this.game.mainPlayer.move(Direction.RIGHT);
        }
        this.game.mainPlayer.faceTowards(this.container.mouse.location);
        if (this.container.mouse.allButtons[SDL_BUTTON_LEFT].isPressed()) {
            this.game.mainPlayer.shootBullet(this.container.mouse.location);
        }
    }

    /**
     * Handles drawing all of the game objects and looking into the game object and drawing a representation of it
     */
    override void draw() {
        foreach (i; 0 .. logicalSize.x / 100) {
            foreach (j; 0 .. logicalSize.y / 100) {
                this.container.renderer.copy(this.textures[Images.Grass],
                        new iRectangle(100 * i, 100 * j, 100, 100));
            }
        }
        foreach (entity; this.game.allEntities) {
            this.container.renderer.copy(this.textures[entity.appearance],
                    new iRectangle(cast(int) entity.location.initialPoint.x,
                        cast(int) entity.location.initialPoint.y, cast(int) entity.location.extent.x,
                        cast(int) entity.location.extent.y), entity.rotation);
        }
    }

}
