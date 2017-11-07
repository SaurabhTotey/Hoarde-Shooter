/**
 * Defines a component that is used for displaying text
 * Useful in conjunction with other components
 * To overlay over another component, look for makeTextOverlay in graphics.views.components
 */
module graphics.views.components.Label;

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

    string text;                ///The text that this label draws
    Font font;                  ///The font the label should draw the text in
    SDL_Color color;            ///The color of the text
    SDL2Surface _textAsSurface; ///The text as a surface is only used to construct the text as a texture
    SDL2Texture _textAsTexture;///The image as a texture that is stored internally
    SDL_Point _startingPoint;   ///The point where the image texture should be drawn

    /**
     * Sets the  location of this component and updates the image as a texture size
     */
    @property override SDL_Rect location(SDL_Rect location){
        this._textAsTexture.destroy();
        this._textAsTexture = null;
        this._location = location;
        //The actual SDLFont that is directly used to create the text; is used internally, as font size is determined within this method: not before or after
        SDLFont literalFont;
        //Finds the biggest font size the text can be while not going out of bounds; makes sure to destroy any unused SDLFonts
        int scaling;
        do{
            literalFont.destroy();
            literalFont = this.font.getFont(scaling);
            scaling++;
        }while(literalFont.measureText(this.text).x < super.location.w && literalFont.measureText(this.text).y < super.location.h);
        literalFont.destroy();
        literalFont = this.font.getFont(scaling - 1);
        //Uses the calculated space taken up for the text to center it within the rectangle location of the component
        SDL_Point fontSize = literalFont.measureText(this.text);
        this._startingPoint = SDL_Point(super.location.x + (super.location.w - fontSize.x) / 2, super.location.y + (super.location.h - fontSize.y) / 2);
        //Gets the correctly placed and scaled text as an SDL2Surface and then has the renderer draw the surface as a texture; makes sure to destroy resources so GFM doesn't complain
        this._textAsSurface = literalFont.renderTextSolid(this.text, this.color);
        literalFont.destroy();
        return super._location;
    }

    /**
     * To make a label, a label must have a location, a text, a font, and an optional color (default color is black)
     * The size of the text is defined by the bounds of the component
     * Text will always be centered within the bounds, and try to fill up as much of the bounds as possible
     */
    this(SDL_Rect location, string text, Font font, SDL_Color color = SDL_Color(0, 0, 0, 255)){
        this.text = text;
        this.font = font;
        this.color = color;
        super(location, SDL_Color(0, 0, 0, 0));
    }

    /**
     * Releases the text as a texture so GFM doesn't complain
     */
    ~this(){
        this._textAsSurface.destroy();
        this._textAsTexture.destroy();
    }

    /**
     * The component's draw method just draws the text of the label
     * Draws the text such that the text fills up as much space as the component has
     * Keeps text centered in bounding rectangle
     */
    override void draw(SDL2Renderer renderer){
        if(this._textAsTexture is null){
            this._textAsTexture = new SDL2Texture(renderer, this._textAsSurface);
            this._textAsSurface.destroy();
        }
        renderer.copy(this._textAsTexture, this._startingPoint.x, this._startingPoint.y);
    }

}
