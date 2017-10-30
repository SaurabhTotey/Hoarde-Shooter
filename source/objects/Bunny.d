module objects.Bunny;

import objects.Entity;

class Bunny: Entity{

    this(Rectangle hitbox){
        super(hitbox, 15);
        this.imagePath = "res/images/DisgustingBunny.png";
    }

    override void tickAction(){
        super.tickAction();
        this.componentVelocities = 0;
    }

}
