module logic.Bunny;

import std.math;
import d2d;
import graphics.Constants;
import logic.Bullet;
import logic.Entity;

/**
 * Possible direction commands for moving the bunny
 */
enum Direction : dVector {
    UP = new dVector(0, -5),
    DOWN = new dVector(0, 5),
    LEFT = new dVector(-5, 0),
    RIGHT = new dVector(5, 0)
}

/**
 * The bunny is the entity in the game that is the player
 */
class Bunny : Entity {

    private double _maxSpeed = 10; ///The highest speed the bunny will be allowed to go at any given point in time

    /**
     * Returns the maximumum speed of the entity
     * Maximumum speed can only be modified internally; otherwise is read only
     */
    @property double maxSpeed() {
        return this._maxSpeed;
    }

    /**
     * Making a bunny sets all of its fields to their defaults
     */
    this() {
        this._appearance = Images.DisgustingBunny;
        this._velocity = new dVector(0);
        this._location = new dRectangle(logicalSize.x / 2 - 50, logicalSize.y / 2 - 50, 100, 100);
        this.health = 100;
    }

    /**
     * The bunny won't slide around; every tick, its velocity gets set to 0, so it is only moving when it is told to
     */
    override void tickAction() {
        this._velocity = 0;
    }

    /**
     * When the bunny goes out of bounds, it gets shifted back such that it is in bounds
     */
    override void outOfBoundsAction() {
        if (this._location.x < 0) {
            this._location.x = 0;
        }
        if (this._location.x + this._location.w > logicalSize.x) {
            this._location.x = logicalSize.x - this._location.w;
        }
        if (this._location.y < 0) {
            this._location.y = 0;
        }
        if (this._location.y + this._location.h > logicalSize.y) {
            this._location.y = logicalSize.y - this._location.h;
        }
    }

    /**
     * The bunny doesn't do anything special when colliding with other entities
     */
    override void onCollide(Entity other) {
    }

    /**
     * Moves the bunny towards the given direction
     */
    void move(Direction direction) {
        this._velocity += direction;
        if (this._velocity.magnitude > this.maxSpeed) {
            this._velocity.magnitude = this.maxSpeed;
        }
    }

    /**
     * Rotates the bunny towards the given point
     */
    void faceTowards(iVector point) {
        dVector difference = new dVector(point.x, point.y) - new dVector(
                this.location.x + 0.5 * this.location.w, this.location.y + 0.5 * this.location.h);
        this._rotation = atan2(difference.y, difference.x) + PI / 2;
    }

    /**
     * Makes the bunny fire a bullet towards the given point
     */
    void shootBullet(iVector towards) {
        dVector bunnyCenter = new dVector(this.location.x + this.location.w / 2, this.location.y + this.location.h / 2);
        this.spawnQueue ~= new Bullet(bunnyCenter, new dVector(towards.x, towards.y) - bunnyCenter, this);
    }

}
