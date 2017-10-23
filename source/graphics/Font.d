/**
 * A module to handle fonts in an easy and convenient way
 * Defines available fonts and has a struct that can easily construct fonts and dig up the font's ttf file (if it is in res/fonts)
 */
module graphics.Font;

import std.conv;
import gfm.sdl2;

/**
 * An enum for font families that a font may take
 * The Calligraphy name must match the name of ttf file in res/fonts so that the font can be made in a standardized simple and easy way
 * Defines how the text will look disregarding size
 */
enum Calligraphy{
    OpenSans, SpecialElite
}

/**
 * A struct for a font that stores the font family as well the utility SDLTTF object to create the font
 * Has a convenient method to make the font from the utility SDLTTF object of the given family
 * Handles getting the font from res/fonts
 * Font is stored in a struct without size because font size can easily change from window resize, and the font should scale with the window
 * The struct separates the actual true font from the size which should be handled internally from components/views
 */
struct Font{

    Calligraphy appearance; ///The font family of the font
    SDLTTF fontCreator;     ///The utility object to create any fonts

    /**
     * Makes an actually usable SDLFont from the stored SDLTTF object and Calligraphy given the font size
     * Handles getting the font from res/fonts as long as the Calligraphy name maps to a .ttf file in res/fonts
     * Any SDLFont returned from this method must be properly disposed of (using .destroy()) so that GFM doesn't complain about relying on the garbage collector
     */
    SDLFont getFont(int size){
        return new SDLFont(this.fontCreator, "res/fonts/" ~ this.appearance.to!string ~ ".ttf", size);
    }

}
