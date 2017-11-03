/**
 * Defines a bullet object
 * Bullets don't have an agenda
 * Bullets are just a stock entity that keep moving at a constant velocity
 */
module objects.Bullet;

import std.math;
import App;
import objects.Entity;

/**
 * A bullet is an entity that moves at a constant velocity
 * It doesn't change direction and is just an entity that moves
 */
class Bullet: Entity{

    immutable int damage = 5;   ///How much damage each bullet does on contact with another entity
    immutable int width = 25;   ///Hitbox width
    immutable int height = 50;  ///Hitbox height
    Entity shooter;             ///The entity that shot this bullet; the shooter of this bullet is immune to it

    /**
     * Creates a bullet in the given initial position that will go towards the given angle at a fixed velocity
     * Angle is in radians
     */
    this(int x, int y, double angle, Entity shooter){
        super("res/images/Bullet.png", Rectangle(x, y, this.width, this.height, angle), 30, 1);
        this.componentVelocities = [cos(angle), sin(angle)];
        this.componentVelocities *= this.maxSpeed;
        this.shooter = shooter;
    }

    /**
     * What the bullet does every tick
     * It does the default entity action of moving, but if it goes out of bounds, it dies
     */
    override void tickAction(){
        if(mainGame.isOutOfBounds(this.hitbox)){
            this.health = 0;
        }
        this.hitbox.x += this.componentVelocities.x;
        this.hitbox.y += this.componentVelocities.y;
    }

    /**
     * A bullet detracts from another entity's health on collision
     */
    override void onCollide(Entity other){
        if(other == this.shooter){
            return;
        }
        other.health -= this.damage;
        this.health = 0;
    }

}
