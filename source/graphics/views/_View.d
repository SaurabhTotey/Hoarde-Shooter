/**
 * A module to store general view information
 * Views are an integral part of this display architecture
 * While a window is just a rectangle, the view defines what shows up in that rectangle
 * Each distinct activity to take place in the window should have its own view
 * Each view should only try and do one task to keep things simple: for more tasks, make more views
 * Flowcharts of programs are usually envisioned in views: they are each distinct steps the user goes through and have different layouts and behaviours
 */
module graphics.views.View;

import std.algorithm;
public import gfm.sdl2;
public import graphics.views.components.Component;
public import graphics.Window;

/**
 * The actual view class
 * Functions similarly to what a view would be in Android
 * A view is one step of the program lifetime, and thus should only be to accomplish a single task
 * For multiple tasks, make multiple views
 * Views define behaviours and layouts for a specific time of the program, but views can contain components that define behaviours and layouts for a specific space of a view
 * This View class is abstract and must be overriden, but has a lot of base functionality
 * A view needs to pass the event on to its components for the components to handle it; this class's methods already do that and can be invoked to automatically pass events to components
 */
abstract class View{

    Window window;              ///The window that the view is in
    Component[] components;     ///The components that the view has: components are widgets that appear on the screen and take up a space that is the only space they define the layout and behave in
    Component focusedComponent; ///The currently focused component that will recieve any ambiguous events TODO add functionality

    /**
     * Constructs a view with a given window so the view can access necessary window information when needed
     */
    this(Window window){
        this.window = window;
    }

    /**
     * The drawing method of the view which takes in the window's renderer
     * Because the view defines how the screen looks at that activity/point in time, a view must override the draw method
     * Has base functionality of drawing all of the view's contained components by calling the components' draw methods
     */
    abstract void draw(SDL2Renderer renderer){
        this.components.each!(component => component.draw(renderer));
    }

    /**
     * An event handler for what the view should do when a key is pressed
     * Takes in the keyboard
     * Default functionality is to just have the focused component handle they key
     */
    void handleKey(SDL2Keyboard keyboard){
        if(this.focusedComponent !is null) this.focusedComponent.handleKey(keyboard);
    }

    /**
     * Handles mouse movement and takes in the SDL2Mouse
     * Default functionality is to just have all components handle mouse functionality, regardless of whether they were actually the ones moused over
     */
    void handleMouseMovement(SDL2Mouse mouse){
        this.components.each!(component => component.handleMouseMovement(mouse));
    }

    /**
     * Handles the mouse click and takes in the button and SDL2Mouse
     * Default functionality is to find components that were clicked and to pass the mouse click event to those components
     */
    void handleMouseClick(ubyte button, SDL2Mouse mouse){
        this.components.filter!(component => component.contains(mouse.position)).each!(component => component.handleMouseClick(button, mouse));
    }

    /**
     * Handles the mouse click release and takes in the button and SDL2Mouse
     * Default functionality is to find components that the mouse was released on and to pass the mouse click release event to those components
     */
    void handleMouseRelease(ubyte button, SDL2Mouse mouse){
        this.components.filter!(component => component.contains(mouse.position)).each!(component => component.handleMouseRelease(button, mouse));
    }

}
