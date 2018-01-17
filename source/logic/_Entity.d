module logic.Entity;

import d2d;
import graphics.Constants;

/**
 * Defines what all objects in the game should be like
 */
abstract class Entity {

    protected bool _isValid = true; ///Whether the entity is valid; if it isn't, the entity gets marked for deletion
    protected Images _appearance; ///How the entity looks
    protected double _rotation = 0; ///Where the entity is facing in radians; is only cosmetic
    protected dVector _velocity; ///The entity's velocity
    protected dRectangle _location; ///The entity's location
    protected int _health; ///The entity's health
    protected int _damage; ///How much damage the entity does

    /**
     * Returns the validity of the entity
     * Validity can only be modified internally; otherwise is read only
     */
    @property bool isValid() {
        return this._isValid;
    }

    /**
     * Returns the appearance of the entity
     * Appearance can only be modified internally; otherwise is read only
     */
    @property Images appearance() {
        return this._appearance;
    }

    /**
     * Returns the rotation of the entity
     * Rotation can only be modified internally; otherwise is read only
     */
    @property double rotation() {
        return this._rotation;
    }

    /**
     * Returns the velocity of the entity
     * Velocity can only be modified internally; otherwise is read only
     */
    @property dVector velocity() {
        return this._velocity;
    }

    /**
     * Returns the location of the entity
     * Location can only be modified internally; otherwise is read only
     */
    @property dRectangle location() {
        return this._location;
    }

    /**
     * Returns the health of the entity
     * Health can only be modified internally; otherwise is read only
     */
    @property int health() {
        return this._health;
    }

    /**
     * Returns the damage of the entity
     * Damage can only be modified internally; otherwise is read only
     */
    @property int damage() {
        return this._damage;
    }

    /**
     * What the entity does every game tick
     */
    final void onTick() {
        if (this.health <= 0) {
            this._isValid = false;
        }
        if (!this._isValid) {
            return;
        }
        this._location.x += this._velocity.x;
        this._location.y += this._velocity.y;
        if (this._location.x < 0
                || this._location.x + this._location.w > logicalSize.x
                || this._location.y < 0 || this._location.y + this._location.h > logicalSize.y) {
            this.outOfBoundsAction();
        }
        this.tickAction();
    }

    void tickAction(); ///The entity's specific action that it does every tick
    void outOfBoundsAction(); ///How the entity handles going out of bounds

}
