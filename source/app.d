module app;

import std.algorithm;
import d2d;
import graphics.Constants;
import graphics.views.MainMenu;

Display mainDisplay;

void main() {
    mainDisplay = new Display(640, 480, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE,
            SDL_RENDERER_ACCELERATED, "Hoarde Shooter!");
    mainDisplay.window.icon = images[Images.DisgustingBunny];
    mainDisplay.window.renderer.logicalSize = new iVector(logicalSize.x, logicalSize.y);
    mainDisplay.eventHandlers ~= new class EventHandler {
        void handleEvent(SDL_Event event) {
            if (mainDisplay.keyboard.allKeys[SDLK_F11].testAndRelease()) {
                SDL_SetWindowFullscreen(mainDisplay.window.handle(), mainDisplay.window.info()
                        .canFind(SDL_WINDOW_FULLSCREEN_DESKTOP) ? 0 : SDL_WINDOW_FULLSCREEN_DESKTOP);
            }
        }
    };
    mainDisplay.screen = new MainMenu(mainDisplay);
    mainDisplay.run();
}
