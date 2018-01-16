module logic.Bunny;

import d2d;
import graphics.Constants;
import logic.Entity;

/**
 * The bunny is the entity in the game that is the player
 */
class Bunny : Entity {

    /**
     * Making a bunny sets all of its fields to their defaults
     */
    this() {
        this._appearance = Images.DisgustingBunny;
        this._velocity = new iVector(0);
        this._location = new iRectangle(logicalSize.x / 2 - 50, logicalSize.y / 2 - 50, 100, 100);
        this._health = 100;
        this._damage = 0;
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

}
