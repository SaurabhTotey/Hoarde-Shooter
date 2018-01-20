module logic.Bullet;

import d2d;
import logic.Entity;
import graphics.Constants;

/**
 * A bullet is a travelling entity that damages other entities
 */
class Bullet : Entity {

    private double speed = 15; ///How fast the bullet will travel

    /**
     * Creates a bullet
     */
    this(dVector startLocation, dVector direction) {
        this._appearance = Images.Bullet;
        this._velocity = direction;
        this._velocity.magnitude = this.speed;
        this._location = new dRectangle(startLocation.x, startLocation.y, 20, 20);
        this.health = 1;
        this._damage = 15;
    }

    /**
     * Bullets don't do anything special every tick
     */
    override void tickAction() {}

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
        other.health -= this.damage;
        this._isValid = false;
    }

}
