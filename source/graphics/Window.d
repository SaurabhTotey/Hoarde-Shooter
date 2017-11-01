/**
 * Contains all of the default and base functionality of a window
 * Doesn't contain any graphics logic, but just a container class for all things needed to have basic functionality
 * Graphics works in an Android and Java esque way where the screen is defined by a view, and a view can contain components
 * Currently uses GFM which is a wrapper built on Derelict-SDL2 built on the actual LibSDL2
 */
module graphics.Window;

import std.conv;
import std.datetime;
import std.experimental.logger;
import gfm.logger;
import gfm.sdl2;
import graphics.views.View;
import graphics.views.Menu;

/**
 * A class that contains all basic objects for basic SDL functionality
 * Is the interface between the user and any graphics processes
 * Events are captured here, but any event behaviour defined in this class is global to the window at any point in time at points inside the window
 * Views define event behaviour for their respective screens, and components define behaviour for their physical space on the screen
 * Must either be scoped or manually destroyed in the runtime of the program or else GFM will complain on relying on the garbage collector
 */
class Window{

    Logger logger;                                  ///The logger for all GFM activities; an SDL2 object requires some form of a logger
    SDL2 sdl;                                       ///The utility object that handles global SDL settings; is used to construct many of the other utility objects
    SDL2Window window;                              ///The actual window that this class represents; is derived from the sdl object
    SDL2Renderer renderer;                          ///The utility object for drawing to the screen of the window; is derived off of the window
    SDLTTF ttf;                                     ///The utility object for drawing text to the screen of the window; is derived from the sdl object
    SDLImage imageCreator;                          ///The utility object for drawing images to the screen of the window; is derived from the sdl object
    View currentScreen;                             ///The current view of the window; defines what the screen of the window is for the most part
    int framerate = 60;                             ///How many times per second the screen updates; is a max, not a guarantee; defaults to 60
    __gshared bool isRunning;                       ///A thread global boolean that can be checked for whether the window is currently running or not
    bool isFullscreen;                              ///A boolean that just contains the state of whether the window is fullscreen or not
    immutable int scaling = 100;                    ///How much to scale the xAspect or yAspect in order to define the logical coordinates
    immutable int xAspect = 16;                     ///The aspect ratio in the x or horizontal dimension
    immutable int yAspect = 9;                      ///The aspect ratio in the y or horizontal dimension
    immutable int logicalX = scaling * xAspect;     ///The logical x is the logical width of the screen; coordinates are defined using this number as the total screen width, and then they get scaled to the actual screen width; this logicalX in conjunction with the logicalY define the aspect ratio that defined components are displayed at
    immutable int logicalY = scaling * yAspect;     ///The logical y is the logical height of the screen; coordinates are defined using this number as the total screen height, and then they get scaled to the actual screen height; this logicalY in conjunction with the logicalX define the aspect ratio that defined components are displayed at

    alias window this;              ///Allows the window to be accessed as the actual SDL2Window that it represents

    /**
     * A constructor for a window
     * Takes in a title and a path to its icon as well as a width and a height, but if none are given, it assumes a resolution of 640x480
     * Sets up all of the window's main fields and utility objects
     */
    this(string title, string pathToIcon = null, int width = 640, int height = 480){
        //Constructs a ConsoleLogger and sets up the sdl object of the window
        this.logger = new ConsoleLogger();
        this.sdl = new SDL2(logger);
        //Uses the constructed sdl object to make the window at the center of the screen with the given width and height that can be resized
        this.window = new SDL2Window(this.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        //Uses the constructed window to get its renderer and set its logical size to correctly scale components as defined by the window's logicalX and logicalY
        this.renderer = new SDL2Renderer(this.window);
        this.renderer.setLogicalSize(this.logicalX, this.logicalY);
        //Uses the constructed sdl object to make a renderer for text that uses the True Type Font format
        this.ttf = new SDLTTF(this.sdl);
        //Makes the utility object to allow the creation of images
        this.imageCreator = new SDLImage(this.sdl);
        //Sets the icon of the window if a path to an icon was provided
        if(pathToIcon !is null){
            SDL2Surface iconSurface = this.imageCreator.load(pathToIcon);
            this.window.setIcon(iconSurface);
            iconSurface.destroy();
        }
        //Sets the window title as the title given to this constructor
        this.window.setTitle(title);
        //Sets the default view as a Menu
        this.currentScreen = new Menu(this);
    }

    /**
     * A destructor for a window
     * Makes sure that all contained resources from GFM are destroyed
     * Exists so that GFM doesn't complain about not correctly releasing resources and relying on the GC
     */
    ~this(){
        this.sdl.destroy();
        this.window.destroy();
        this.renderer.destroy();
    }

    /**
     * Returns a rectangle that gets the area in the window that can be drawn to
     * Returns the area between the window's letterboxes
     * TODO this doesn't work well
     */
    SDL_Rect getDrawableArea(){
        int x;
        int y;
        if(this.window.getWidth() / this.xAspect > this.window.getHeight() / this.yAspect){
            x = this.logicalY / this.window.getHeight() * (this.window.getWidth() - xAspect * this.window.getHeight() / yAspect) / 2;
        }else{
            y = this.logicalX / this.window.getWidth() * (this.window.getHeight() - yAspect * this.window.getWidth() / xAspect) / 2;
        }
        return SDL_Rect(x, y, this.logicalX, this.logicalY);
    }

    /**
     * Clears the entire buffer (unseen screen) with just black
     * If clear and then renderer.present() were called, the screen would be entirely black
     */
    void clear(){
        this.renderer.setViewportFull();
        this.renderer.setColor(0, 0, 0);
        this.renderer.clear();
        SDL_Rect drawableArea = this.getDrawableArea();
        this.renderer.setViewport(drawableArea.x, drawableArea.y, drawableArea.w, drawableArea.h);
    }

    /**
     * Clears the buffer's viewport with the given RGBA color
     * Doesn't affect any letterbox affects, as those should remain black
     * TODO center this affect so letterboxes happen on both sides
     */
    void clear(int r, int g, int b, int a = 255){
        this.clear();
        this.renderer.setColor(r, g, b, a);
        this.renderer.fillRect(0, 0, this.logicalX, this.logicalY);
    }

    /**
     * Main method of the window
     * Handles all incoming events, but doesn't actually handle event logic: just sends events to appropriate views to be handled
     * Runs until the window is closed by the user; is blocking
     * Doesn't/shouldn't handle actual game logic
     * Window isn't running until this method is called, and window stops running once this method ends
     */
    void run(){
        this.isRunning = true;  //Sets the state of the window to running
        SysTime lastTickTime;   //The time of the last tick; is used for framerate calculations
        //Runs while a window quit hasn't been requested and while it is counted as still being running
        while(!this.sdl.wasQuitRequested() && this.isRunning){
            //Clears the buffer
            this.clear();
            //Polls for events given to the window from the user and sends them off to be handled by appropriate methods
            SDL_Event event;
            while(this.sdl.pollEvent(&event)){
                switch(event.type){
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
            //Handles the keyboard input at the fastest speed this while loop can go
            this.handleKey(this.sdl.keyboard);
            //Draws on the buffer based on what the current view defines and then switches buffers; handles framerate if Vsync isn't enabled TODO test that framerate cap actually works
            this.currentScreen.draw(this.renderer);
            if(this.renderer.info.isVsyncEnabled || Clock.currTime >= lastTickTime + dur!"msecs"((1000.0 / this.framerate).to!int)){
                lastTickTime = Clock.currTime;
                this.renderer.present();
            }
        }
        //Now that the window has stopped running because a quit was requested, marks the window as not running
        this.isRunning = false;
    }

    /**
     * A method to handle keypresses
     * Any behaviour defined here is global
     * Otherwise, the keyboard is then passed on to the current view to handle pressed keys
     */
    void handleKey(SDL2Keyboard keyboard){
        if(keyboard.testAndRelease(SDLK_F11)){
            if(!isFullscreen){
                this.window.setFullscreenSetting(SDL_WINDOW_FULLSCREEN_DESKTOP);
            }else{
                this.window.setFullscreenSetting(0);
            }
            this.isFullscreen = !this.isFullscreen;
        }
        this.currentScreen.handleKey(keyboard);
    }

    /**
     * A method to handle mouse movement
     * Any behaviour defined here is global
     * Otherwise, the movement is then passed on to the current view to handle the movement
     */
    void handleMouseMovement(){
        this.currentScreen.handleMouseMovement(this.sdl.mouse);
    }

    /**
     * A method to handle mouse clicks
     * Any behaviour defined here is global
     * Otherwise, the click is then passed on to the current view to handle the click
     * There shouldn't be any reason for there to be a global handle on mouse clicks
     */
    void handleMouseClick(ubyte button){
        this.currentScreen.handleMouseClick(button, this.sdl.mouse);
    }

    /**
     * A method to handle mouse click releases
     * Any behaviour defined here is global
     * Otherwise, the click release is then passed on to the current view to handle the click release
     * There shouldn't be any reason for there to be a global handle on mouse click releases
     */
    void handleMouseRelease(ubyte button){
        this.currentScreen.handleMouseRelease(button, this.sdl.mouse);
    }

}
