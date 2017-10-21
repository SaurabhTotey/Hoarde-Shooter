module graphics.Window;

import std.experimental.logger;
import gfm.logger;
import gfm.sdl2;
import graphics.views.View;
import graphics.views.Menu;

class Window{

    Logger logger;
    SDL2 sdl;
    SDL2Window window;
    SDL2Renderer renderer;
    SDLTTF sdlTTF;
    SDLFont titleFont;
    SDLFont defaultFont;
    __gshared bool isRunning;
    bool isFullscreen;
    View currentScreen;

    alias window this;

    this(int width = 640, int height = 480){
        this.logger = new ConsoleLogger();
        this.sdl = new SDL2(logger);
        this.window = new SDL2Window(this.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        this.renderer = new SDL2Renderer(this.window, SDL_RENDERER_SOFTWARE);
        this.sdlTTF = new SDLTTF(this.sdl);
        this.titleFont = new SDLFont(this.sdlTTF, "res/fonts/SpecialElite.ttf", this.window.getWidth() / 15);
        this.defaultFont = new SDLFont(this.sdlTTF, "res/fonts/SpecialElite.ttf", this.window.getWidth() / 20);
        this.window.setTitle("Hoarde Shooter");
        this.currentScreen = new Menu(this);
    }

    ~this(){
        this.sdl.destroy();
        this.window.destroy();
        this.renderer.destroy();
    }

    void clear(){
        this.renderer.setViewportFull();
        this.renderer.setColor(0, 0, 0);
        this.renderer.clear();
    }

    void run(){
        this.isRunning = true;
        while(!this.sdl.wasQuitRequested()){
            this.clear();
            SDL_Event event;
            while(this.sdl.pollEvent(&event)){
                switch(event.type){
                    case SDL_KEYDOWN:{
                        this.handleKey(event.key.keysym);
                        break;
                    }
                    case SDL_MOUSEMOTION:{
                        this.handleMouseMovement();
                        break;
                    }
                    case SDL_MOUSEBUTTONDOWN:{
                        this.handleMouseClick(event.button.button);
                        break;
                    }
                    case SDL_MOUSEBUTTONUP:{
                        this.handleMouseRelease(event.button.button);
                        break;
                    }
                    default:break;
                }
            }
            this.currentScreen.draw(this.renderer);
            this.renderer.present();
        }
        this.isRunning = false;
    }

    void handleKey(SDL_Keysym key){
        switch(key.sym){
            case SDLK_F11:{
                if(!isFullscreen){
                    this.window.setFullscreenSetting(SDL_WINDOW_FULLSCREEN_DESKTOP);
                }else{
                    this.window.setFullscreenSetting(0);
                }
                this.isFullscreen = !this.isFullscreen;
                break;
            }
            default:break;
        }
        this.currentScreen.handleKey(key);
    }

    void handleMouseMovement(){
        this.currentScreen.handleMouseMovement(this.sdl.mouse);
    }

    void handleMouseClick(ubyte button){
        this.currentScreen.handleMouseClick(button, this.sdl.mouse);
    }

    void handleMouseRelease(ubyte button){
        this.currentScreen.handleMouseRelease(button, this.sdl.mouse);
    }

}
