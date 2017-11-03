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

    /**
     * Returns the rectangle's vertices in a clockwise order starting from the top left
     */
    @property double[][] vertices(){
        double semiDiagonal = sqrt(this.w.pow(2) + this.h.pow(2));
        double x1 = this.x - semiDiagonal * cos(this.rotation);
        double y1 = this.y + semiDiagonal * sin(this.rotation);
        double x2 = this.x + semiDiagonal * cos(this.rotation);
        double y2 = this.y - semiDiagonal * sin(this.rotation);
        return [[x1, y1], [x2, y1], [x2, y2], [x1, y2]];
    }
}

/**
 * Returns whether two rectangles contain any overlap
 * TODO make this
 */
bool intersects(Rectangle first, Rectangle second){
    return false;
}
