/**
 * Defines a bullet object
 * Bullets don't have an agenda
 * Bullets are just a stock entity that keep moving at a constant velocity
 */
module objects.Bullet;

import std.math;
import objects.Entity;

/**
 * A bullet is an entity that moves at a constant velocity
 * It doesn't change direction and is just an entity that moves
 */
class Bullet: Entity{

    immutable int damage = 5;   ///How much damage each bullet does on contact with another entity
    immutable int width = 25;   ///Hitbox width
    immutable int height = 50;  ///Hitbox height

    /**
     * Creates a bullet in the given initial position that will go towards the given angle at a fixed velocity
     * Angle is in radians
     */
    this(int x, int y, double angle){
        super("res/images/Bullet.png", Rectangle(x, y, this.width, this.height, angle), 30);
        this.componentVelocities = [cos(angle), sin(angle)];
        this.componentVelocities *= this.maxSpeed;
    }

}
