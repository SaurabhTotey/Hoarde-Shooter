/**
 * Defines a component that is used for displaying text
 * Useful in conjunction with other components
 * To overlay over another component, look for makeTextOverlay in graphics.views.components
 */
module graphics.views.components.Label;

import std.typecons;
public import graphics.Font;
import graphics.views.components.Pane;

/**
 * A label is a component that only draws text
 * Doesn't do any special event handling
 * Uses SDLTTF to render text
 * Text rendered by this label is un-editable by the user and its size is defined by its bounding rectangle
 * Text is centered within its bounds
 */
class Label: Pane{

    string text;        ///The text that this label draws
    Font font;          ///The font the label should draw the text in
    SDL_Color color;    ///The color of the text

    /**
     * To make a label, a label must have a location, a text, a font, and an optional color (default color is black)
     * The size of the text is defined by the bounds of the component
     * Text will always be centered within the bounds, and try to fill up as much of the bounds as possible
     */
    this(SDL_Rect location, string text, Font font, SDL_Color color = SDL_Color(0, 0, 0, 255)){
        super(location);
        this.text = text;
        this.font = font;
        this.color = color;
    }

    /**
     * The component's draw method just draws the text of the label
     * Draws the text such that the text fills up as much space as the component has
     * Keeps text centered in bounding rectangle
     */
    override void draw(SDL2Renderer renderer){
        //The actual SDLFont that is directly used to create the text; is used internally, as font size is determined within this method: not before or after
        SDLFont literalFont;
        //Finds the biggest font size the text can be while not going out of bounds; makes sure to destroy any unused SDLFonts
        int scaling;
        do{
            literalFont.destroy();
            literalFont = this.font.getFont(scaling);
            scaling++;
        }while(literalFont.measureText(this.text).x < this.location.w && literalFont.measureText(this.text).y < this.location.h);
        literalFont.destroy();
        literalFont = this.font.getFont(scaling - 1);
        //Uses the calculated space taken up for the text to center it within the rectangle location of the component
        SDL_Point fontSize = literalFont.measureText(this.text);
        SDL_Point startingPoint = SDL_Point(this.location.x + (this.location.w - fontSize.x) / 2, this.location.y + (this.location.h - fontSize.y) / 2);
        //Gets the correctly placed and scaled text as an SDL2Surface and then has the renderer draw the surface as a texture; makes sure to destroy resources so GFM doesn't complain
        SDL2Surface textAsSurface = literalFont.renderTextSolid(this.text, this.color);
        literalFont.destroy();
        renderer.copy(scoped!SDL2Texture(renderer, textAsSurface), startingPoint.x, startingPoint.y);
        textAsSurface.destroy();
    }

}
