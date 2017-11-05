/**
 * Defines a wolf object
 * Wolves are the main enemies in the game and come in a few varieties
 */
module objects.Wolf;

import objects.Bunny;
import objects.Entity;

/**
 * A wolf is an entity that is in the world
 * They are like all other entities except they chase the player
 * Can be made in a few different flavors/varieties
 */
class Wolf: Entity{

    int damage; ///How much damage this wolf does when in contact with another player

    /**
     * A constructor for a wolf
     * Takes in a rectangle as a size
     */
    this(Rectangle hitbox){
        //TODO change image path and scale health and damage off of size
        super("res/images/DisgustingWolf.png", hitbox, 20, 1);
    }

    /**
     * What the wolf does every turn
     * Wolves try and chase the player and move towards the player
     */
    override void tickAction(){
        //TODO find player and adjust velocity to move towards player
        super.tickAction();
    }

    /**
     * What the wolf does when colliding with another entity
     * Wolves hurt bunnies
     */
    override void onCollide(Entity other){
        if(cast(Bunny) other){
            other.health -= this.damage;
        }
    }
}
