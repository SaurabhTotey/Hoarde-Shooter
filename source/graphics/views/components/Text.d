module graphics.views.components.Text;

import std.typecons;
import graphics.views.components.Pane;

class Text: Pane{

    immutable string text;
    SDLFont font;
    SDL_Color color;

    this(SDL_Point location, string text, SDLFont font, SDL_Color color = SDL_Color(0, 0, 0, 255)){
        this.text = text;
        this.font = font;
        this.color = color;
        SDL_Point size = this.font.measureText(text);
        super(SDL_Rect(location.x, location.y, size.x, size.y));
    }

    override void draw(SDL2Renderer renderer){
        SDL2Surface textAsSurface = this.font.renderTextSolid(this.text, this.color);
        renderer.copy(scoped!SDL2Texture(renderer, textAsSurface), this.location.x, this.location.y);
        textAsSurface.destroy();
    }

}
