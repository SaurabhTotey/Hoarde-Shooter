module graphics.views.MainGame;

import d2d;
import graphics.Constants;
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
    }

    /**
     * Handles collecting events to send to the game object logic controller
     */
    void handleEvent(SDL_Event event) {
    }

    /**
     * A method required by Screen; doesn't serve any purpose for the MainGame screen
     */
    override void onFrame() {
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
