module graphics.views.components.Button;

import std.datetime;
import graphics.views.components.Pane;

abstract class Button: Pane{

    immutable Duration expectReleaseIn = dur!"msecs"(650);
    SysTime lastPressed;

    this(SDL_Rect location){
        super(location);
    }

    override void handleMouseClick(ubyte button, SDL2Mouse mouse){
        if(button != SDL_BUTTON_LEFT) return;
        this.lastPressed = Clock.currTime;
    }

    override void handleMouseRelease(ubyte button, SDL2Mouse mouse){
        if(button != SDL_BUTTON_LEFT || this.lastPressed + this.expectReleaseIn < Clock.currTime) return;
        this.action();
    }

    void action();

}
