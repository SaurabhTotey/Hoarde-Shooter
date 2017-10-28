/**
 * Defines a component used for displaying an image
 * Useful in conjunction with other components
 * To overlay over another component, look for makeImageOverlay in graphics.views.components
 */
module graphics.views.components.Image;

import graphics.views.components.Pane;

/**
 * An image is a component that also displays an image
 * Takes in the path and then loads the image every time it is needed
 * Can definitely be optimized
 */
class Image: Pane{

    string path;            ///The file path to the image
    SDLImage imageCreator;  ///The utility object that creates the image
    SDL2 sdl;               ///The object that will allow creation of surfaces

    /**
     * The constructor for an image
     * Takes in a location which is required by all components, a path to the image so an actual image may be loaded, and an SDL utility object to create images, as well as the sdl object itself
     * The size of the image is bounded by its rectangle location, and is stretched to fit
     * Ideally, the rectangle is always in the same proportions as the original image
     */
    this(SDL_Rect location, string path, SDLImage imageCreator, SDL2 sdl){
        super(location);
        this.path = path;
        this.imageCreator = imageCreator;
        this.sdl = sdl;
    }

    /**
     * Where loading and drawing the image is handled
     * Makes image such that it fills up entire area of the component's location
     */
    override void draw(SDL2Renderer renderer){
        //Loads the original image in original resolution and makes the surface into a texture
        SDL2Surface imageAsSurface = this.imageCreator.load(this.path);
        SDL2Texture imageAsTexture = new SDL2Texture(renderer, imageAsSurface);
        //Renders the texturized version of the surface with the correct scaling
        renderer.copy(imageAsTexture, SDL_Rect(0, 0, imageAsTexture.width, imageAsTexture.height), this.location);
        //Destroys loaded image texture and surface so GFM doesn't complain
        imageAsTexture.destroy();
        imageAsSurface.destroy();
    }

}
