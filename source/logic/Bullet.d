module logic.Bullet;

import std.math;
import d2d;
import logic.Entity;
import graphics.Constants;

/**
 * A bullet is a travelling entity that damages other entities
 */
class Bullet : Entity {

    private Entity immune; ///Which entity is immune to the bullet
    immutable speed = 30.0; ///How fast the bullet will travel
    immutable damage = 15; ///How much damage the bullet does

    /**
     * Creates a bullet
     */
    this(dVector startLocation, dVector direction, Entity immune) {
        this.immune = immune;
        this._appearance = Images.Bullet;
        this._velocity = direction;
        this._velocity.magnitude = this.speed;
        this._rotation = atan2(this.velocity.y, this.velocity.x) + PI / 2;
        this._location = new dRectangle(startLocation.x, startLocation.y, 20, 20);
        this.health = 1;
    }

    /**
     * Bullets don't do anything special every tick
     */
    override void tickAction() {
    }

    /**
     * Bullets just become invalidated once they are out of bounds
     */
    override void outOfBoundsAction() {
        this._isValid = false;
    }

    /**
     * When a bullet collides with another entity, it damages the other entity and then becomes invalid
     */
    override void onCollide(Entity other) {
        if (other == this.immune || (cast(Bullet) other && (cast(Bullet) other).immune
                == this.immune)) {
            return;
        }
        other.health -= this.damage;
        this._isValid = false;
    }

}
