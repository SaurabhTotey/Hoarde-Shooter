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
        SDLFont literalFont;
        int scaling;
        do{
            literalFont.destroy();
            literalFont = this.font.getFont(scaling);
            scaling++;
        }while(literalFont.measureText(this.text).x < this.location.w && literalFont.measureText(this.text).y < this.location.h);
        literalFont.destroy();
        literalFont = this.font.getFont(scaling - 1);
        SDL_Point fontSize = literalFont.measureText(this.text);
        SDL_Point startingPoint = SDL_Point(this.location.x + (this.location.w - fontSize.x) / 2, this.location.y + (this.location.h - fontSize.y) / 2);
        SDL2Surface textAsSurface = literalFont.renderTextSolid(this.text, this.color);
        literalFont.destroy();
        renderer.copy(scoped!SDL2Texture(renderer, textAsSurface), startingPoint.x, startingPoint.y);
        textAsSurface.destroy();
    }

}
