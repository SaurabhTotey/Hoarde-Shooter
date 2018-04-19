module logic.Bullet;

import std.math;
import d2d;
import logic.Entity;
import logic.Event;
import logic.Game;
import graphics.Constants;

/**
 * A bullet is a travelling entity that damages other entities
 */
class Bullet : Entity {

    private Entity immune; ///Which entity is immune to the bullet
    immutable speed = 30.0; ///How fast the bullet will travel
    immutable damage = 10; ///How much damage the bullet does

    /**
     * Creates a bullet
     */
    this(Game container, dVector startLocation, dVector direction, Entity immune) {
        super(container);
        this.immune = immune;
        this._appearance = Images.Bullet;
        this._velocity = direction;
        this._velocity.magnitude = this.speed;
        this._rotation = atan2(direction.y, direction.x) + PI / 2;
        this._location = new dRectangle(startLocation.x, startLocation.y, 20, 20);
        this.health = 1;
        this.sendEvent(Event("BULLET FIRED", "Bullet fired by " ~ immune.toString()));
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
        if (other.health < 0) {
            this.game.difficulty++;
        }
        this._isValid = false;
    }

}
