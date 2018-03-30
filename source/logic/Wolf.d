module logic.Wolf;

import std.math;
import d2d;
import graphics.Constants;
import logic.Bunny;
import logic.Entity;
import logic.Game;

/**
 * The wolf is the entity in the game that serves as the main enemy
 */
class Wolf : Entity {

    private immutable int difficulty; ///How advanced or tough this wolf is: affects size, speed, and damage

    /**
     * Initializes wolf properties
     */
    this(Game container, dVector location, int difficulty) {
        super(container);
        this._appearance = Images.DisgustingWolf;
        this._velocity = new dVector(0);
        this._location = new dRectangle(location, new dVector(100, 100) + difficulty);
        this.health = difficulty;
        this.difficulty = difficulty;
    }

    /**
     * Every tick, the wolf tries to go towards the main player
     */
    override void tickAction() {
        this._velocity = this.game.mainPlayer.location.center - this.location.center;
        this._velocity.magnitude = this.difficulty;
        this._rotation = atan2(this._velocity.y, this._velocity.x);
    }

    /**
     * Wolf doesn't do anything special when out of bounds
     */
    override void outOfBoundsAction() {
    }

    /**
     * When a wolf collides with another bunny, it damages it
     */
    override void onCollide(Entity other) {
        if (!cast(Bunny) other) {
            return;
        }
        other.health -= this.difficulty;
    }

}