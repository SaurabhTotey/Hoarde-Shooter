module logic.Entity;

import d2d;
import graphics.Constants;
import logic.Game;

/**
 * Defines what all objects in the game should be like
 */
abstract class Entity {

    protected Game game; ///The game that this entity exists within
    private ulong _lifeTime; ///How many ticks the entity has lived
    protected bool _isValid = true; ///Whether the entity is valid; if it isn't, the entity gets marked for deletion
    protected Images _appearance; ///How the entity looks
    protected double _rotation = 0; ///Where the entity is facing in radians; is only cosmetic
    protected dVector _velocity; ///The entity's velocity
    protected dRectangle _location; ///The entity's location
    package Entity[] spawnQueue; ///Anything the entity wants to spawn; will periodically get emptied and placed in the game
    int health; ///The entity's health

    /**
     * All entities must take in the game that they are contained in
     */
    this(Game container) {
        this.game = container;
    }

    /**
     * Returns the liftime of the entity
     * Lifetime can only be modified internally; otherwise is read only
     */
    @property ulong lifeTime() {
        return this._lifeTime;
    }

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
     * What the entity does every game tick
     */
    final void onTick() {
        if (this.health <= 0) {
            this._isValid = false;
        }
        if (!this._isValid) {
            return;
        }
        this._location.initialPoint.x += this._velocity.x;
        this._location.initialPoint.y += this._velocity.y;
        if (this._location.initialPoint.x < 0
                || this._location.initialPoint.x + this._location.extent.x > logicalSize.x
                || this._location.initialPoint.y < 0 || this._location.initialPoint.y + this._location.extent.y > logicalSize.y) {
            this.outOfBoundsAction();
        }
        this.tickAction();
        this._lifeTime++;
    }

    void tickAction(); ///The entity's specific action that it does every tick
    void outOfBoundsAction(); ///How the entity handles going out of bounds
    void onCollide(Entity other); ///What the entity does when colliding with another entity

}
