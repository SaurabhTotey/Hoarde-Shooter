module graphics.views.Main;

import App;
import graphics.views.components.Image;
import graphics.views.View;

class Main: View{

    this(Window window){
        super(window);
        this.components ~= new Image(SDL_Rect(750, 400, 100, 100), "res/images/DisgustingBunny.png", this.window.imageCreator, this.window.sdl);
    }

    override void draw(SDL2Renderer renderer){
        this.window.clear(0, 255, 0);
        super.draw(renderer);
    }

}
