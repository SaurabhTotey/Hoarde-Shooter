/**
 * Defines a superclass that every object in the world must inherit from
 * Also defines many useful utility structs and functions to use along with the Entity class
 */
module objects.Entity;

import std.algorithm;
import std.math;
import std.string;
import gfm.math;

/**
 * An entity is an object that can exist in the world
 * Almost everything in the game is an entity
 */
abstract class Entity{

    string imagePath;                       ///The path to the image that would represent this entity
    Rectangle hitbox;                       ///The bounds for where this entity actually takes up space or exists within the world
    immutable int maxSpeed;                 ///The highest speed this entity can travel at; speed is the magnitude of the velocities
    Vector!(double, 2) componentVelocities; ///A velocity vector of an entity where the x component is the x velocity and the y component is the y velocity
    int health;                             ///How much health the entity has

    /**
     * Necessary constructor for any entity
     * Takes in a path for its representative image, a hitbox, a max speed, and a health because all entities need those
     */
    this(string imagePath, Rectangle hitbox, int maxSpeed, int health){
        this.imagePath = imagePath;
        this.hitbox = hitbox;
        this.maxSpeed = maxSpeed;
        this.health = health;
        this.componentVelocities = 0;
    }

    /**
     * What the entity does every tick of the game
     * Default implementation is to move the entity based on its velocity
     * Scales the velocity down to the maxSpeed if the velocity magnitude ever exceeds the max speed
     */
    void tickAction(){
        //Normalizes component velocities such that they become compliant with the max speed
        if(this.componentVelocities.length > this.maxSpeed){
            this.componentVelocities = this.componentVelocities.normalized * this.maxSpeed;
        }
        //Moves the entity by the velocity TODO prevent entities from going out of bounds
        this.hitbox.x += this.componentVelocities.x;
        this.hitbox.y += this.componentVelocities.y;
    }

    /**
     * What the entity should do when colliding with another entity
     */
    void onCollide(Entity other);

}

/**
 * A class that essentially mimics SDL_Rect
 * Isn't just an SDL_Rect because SDL2 is needed for SDL_Rect, and a separation of graphics from logic was wanted
 */
struct Rectangle{
    double x;               ///The x coordinate of the middle of rectangle
    double y;               ///The y coordinate of the middle of the rectangle
    double w;               ///The width of the rectangle
    double h;               ///The height of the rectangle
    double rotation = 0;    ///The rotation of the rectangle in radians
}

/**
 * Returns whether two rectangles contain any overlap
 * This implementation isn't perfect but essentially checks collisions as if the rectangles were circles with radii of their smallest dimension
 * This gives a good approximation for collision, but isn't completely accurate
 */
bool intersects(Rectangle first, Rectangle second){
    //Takes the radius as the addition of both rectangles' smallest dimensions
    double radius = ((first.w < first.h)? first.w : first.h) + ((second.w < second.h)? second.w : second.h);
    //Returns whether the distance is smaller than half the radius
    return sqrt((first.x - second.x).pow(2) + (first.y - second.y).pow(2)) < radius / 2;
}
