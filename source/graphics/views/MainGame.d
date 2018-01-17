module graphics.views.MainGame;

import core.thread;
import d2d;
import graphics.Constants;
import logic.Bunny;
import logic.game;

/**
 * The screen where the actual game is played; stores the game and all of its resources
 */
class MainGame : Screen {

    Game game; ///The actual game object that handles logic and flow
    Texture[Images] textures; ///The textures used by the game
    Sound!(SoundType.Music) spinningSong; ///The game's background music

    /**
     * Makes a MainGame screen that creates the screen's game and loads all textures and sounds
     */
    this(Display container) {
        super(container);
        this.game = new Game();
        foreach (image, surface; images) {
            this.textures[image] = new Texture(surface, this.container.window.renderer);
        }
        this.spinningSong = new Sound!(SoundType.Music)("res/sounds/music/SpinningSong.wav");
        new Thread({ this.game.run(); }).start();
    }

    /**
     * Handles collecting events to send to the game object logic controller
     */
    void handleEvent(SDL_Event event) {
        if (event.type == SDL_QUIT) {
            this.game.isRunning = false;
        }
    }

    /**
     * Because this method gets called periodically and uniformly, sends input data to game in uniform rate
     */
    override void onFrame() {
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
    }

    /**
     * Handles drawing all of the game objects and looking into the game object and drawing a representation of it
     */
    override void draw() {
        foreach (i; 0 .. logicalSize.x / 100) {
            foreach (j; 0 .. logicalSize.y / 100) {
                this.container.window.renderer.copy(this.textures[Images.Grass],
                        new iRectangle(100 * i, 100 * j, 100, 100));
            }
        }
        foreach (entity; this.game.allEntities) {
            this.container.window.renderer.copy(this.textures[entity.appearance],
                    new iRectangle(cast(int) entity.location.x,
                        cast(int) entity.location.y, cast(int) entity.location.w,
                        cast(int) entity.location.h), entity.rotation);
        }
    }

}
