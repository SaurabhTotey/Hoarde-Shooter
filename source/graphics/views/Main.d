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

    override void handleKey(SDL_Keysym key){
        switch(key.sym){
            case SDLK_w:{
                this.components[0].location.y -= 10;
                break;
            }
            case SDLK_s:{
                this.components[0].location.y += 10;
                break;
            }
            case SDLK_a:{
                this.components[0].location.x -= 10;
                break;
            }
            case SDLK_d:{
                this.components[0].location.x += 10;
                break;
            }
            default: break;
        }
    }

}
