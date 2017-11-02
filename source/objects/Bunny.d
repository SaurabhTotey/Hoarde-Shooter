/**
 * Defines a bunny object
 * Is the entity that the player controls
 */
module objects.Bunny;

import App;
import objects.Entity;

/**
 * A bunny is an entity the player controls
 * Its velocity at every tick gets set to 0
 */
class Bunny: Entity{

    /**
     * Creates a bunny given an initial hitbox
     * Bunnies always have a maximum velocity of 25
     */
    this(Rectangle hitbox){
        super("res/images/DisgustingBunny.png", hitbox, 25, 100);
    }

    /**
     * What the bunny does every turn
     * Bunnies just lose their velocity and come to an instant stop after having updated their position
     */
    override void tickAction(){
        super.tickAction();
        this.componentVelocities = 0;
    }

    /**
     * Bunnies do nothing on collision with other entities
     */
    override void onCollide(Entity other){}

}
