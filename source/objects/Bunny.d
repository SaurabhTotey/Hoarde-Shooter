module objects.Bunny;

import objects.Entity;

class Bunny: Entity{

    this(Rectangle hitbox){
        super(hitbox, 5);
        this.imagePath = "res/images/DisgustingBunny.png";
    }

    override void tickAction(){
        super.tickAction();
    }

}
