module graphics.Constants;

import std.conv;
import std.traits;
import d2d;

immutable logicalSize = new iVector(1600, 900); ///The logical size of the renderer

Font[Fonts] fonts; ///All fonts; array is preloaded so fonts don't need to be needlessly loaded afterwards
Surface[Images] images; ///All images; array is preloaded so images don't need to be needlessly loaded afterwards

shared static this() {
    foreach (font; EnumMembers!Fonts) {
        fonts[font] = new Font("res/fonts/" ~ font.to!string ~ ".ttf", 14);
    }
    foreach (image; EnumMembers!Images) {
        images[image] = loadImage("res/images/" ~ image.to!string ~ ".png");
    }
}

/**
 * All fonts that show up in the game
 */
enum Fonts {
    OpenSans,
    SpecialElite
}

/**
 * All images that show up in the game
 */
enum Images {
    Bullet,
    DisgustingBunny,
    DisgustingWolf,
    Grass
}

/**
 * All sound effects that show up in the game
 */
enum SoundEffects {
    NONE
}

/**
 * All music that shows up in the game
 */
enum SoundMusic {
    SpinningSong
}
