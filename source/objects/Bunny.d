module objects.Bunny;

import objects.Entity;

class Bunny: Entity{

    override void tickAction(){
        super.tickAction();
        this.componentVelocities = 0;
    }

}
