/**
 * Defines a superclass that every object in the world must inherit from
 * Also defines many useful utility structs and functions to use along with the Entity class
 */
module objects.Entity;

import std.algorithm;
import std.conv;
import std.string;
import gfm.math;

/**
 * An entity is an object that can exist in the world
 * Almost everything in the game is an entity
 */
abstract class Entity{

    Rectangle hitbox;                       ///The bounds for where this entity actually takes up space or exists within the world
    immutable int maxSpeed;                 ///The highest speed this entity can travel at; speed is the magnitude of the velocities
    Vector!(double, 2) componentVelocities; ///A velocity vector of an entity where the x component is the x velocity and the y component is the y velocity
    string imagePath;                       ///The path to the image that would represent this entity

    /**
     * Necessary constructor for any entity
     * Takes in a hitbox and a max speed because all entities need those
     */
    this(Rectangle hitbox, int maxSpeed){
        this.hitbox = hitbox;
        this.maxSpeed = maxSpeed;
        this.componentVelocities = 0;
    }

    /**
     * Adds a number to one of either the x or y velocities
     * Ensures that the velocity stays under the maxSpeed cap
     */
    void addToVelocity(char velocityComponent)(double amountToAdd){
        static assert("xy".canFind(velocityComponent.toLower()));  //Ensures that velocityComponent is either 'x' or 'y'
        mixin("double* component = &this.componentVelocities." ~ velocityComponent.toLower().to!string ~ ";");  //In compile time, sets a pointer to the component based on the template parameter of velocityComponent
        *component += amountToAdd;  //In runtime, adds the amountToAdd given in the function to the pointer that was set in compile time
        if(this.componentVelocities.length > this.maxSpeed){
            this.componentVelocities = this.componentVelocities.normalized * this.maxSpeed; //Scales the componentVelocities so that they are compliant with the max speed
        }
    }

    /**
     * What the entity does every tick of the game
     * Default implementation is to move the entity based on its velocity
     */
    void tickAction(){
        this.hitbox.x += this.componentVelocities.x.to!int;
        this.hitbox.y += this.componentVelocities.y.to!int;
    }

}

/**
 * A class that essentially mimics SDL_Rect
 * Isn't just an SDL_Rect because SDL2 is needed for SDL_Rect, and a separation of graphics from logic was wanted
 */
struct Rectangle{
    int x;                  ///The x coordinate of the top left vertex of the rectangle
    int y;                  ///The y coordinate of the top left vertex of the rectangle
    int w;                  ///The width of the rectangle
    int h;                  ///The height of the rectangle
    double rotation = 0;    ///The rotation of the rectangle in radians
}

/**
 * Returns whether two rectangles contain any overlap
 * TODO account for rotation
 */
bool intersect(Rectangle first, Rectangle second){
    return first.x < second.x + second.w && first.x + first.w > second.x && first.y < second.y + second.h && first.h + first.y > second.y;
}
