module graphics.Font;

import std.conv;
import gfm.sdl2;

enum Calligraphy{
    OpenSans, SpecialElite
}

struct Font{

    Calligraphy appearance;
    SDLTTF fontCreator;

    SDLFont getFont(int size){
        return new SDLFont(this.fontCreator, "res/fonts/" ~ this.appearance.to!string ~ ".ttf", size);
    }

}
