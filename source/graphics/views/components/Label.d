module graphics.views.components.Label;

import std.typecons;
public import graphics.Font;
import graphics.views.components.Pane;

class Label: Pane{

    string text;
    Font font;
    SDL_Color color;

    this(SDL_Rect location, string text, Font font, SDL_Color color = SDL_Color(0, 0, 0, 255)){
        super(location);
        this.text = text;
        this.font = font;
        this.color = color;
    }

    override void draw(SDL2Renderer renderer){
        SDLFont literalFont = this.font.getFont(0);
        int scaling;
        for(int i = 1; literalFont.measureText(this.text).x < this.location.w && literalFont.measureText(this.text).y < this.location.h; i++){
            literalFont.destroy();
            literalFont = this.font.getFont(i);
            scaling = i;
        }
        literalFont.destroy();
        literalFont = this.font.getFont(scaling - 1);
        SDL2Surface textAsSurface = literalFont.renderTextSolid(this.text, this.color);
        literalFont.destroy();
        renderer.copy(scoped!SDL2Texture(renderer, textAsSurface), this.location.x, this.location.y);
        textAsSurface.destroy();
    }

}
