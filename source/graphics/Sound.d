/**
 * The module that defines how sounds are handled
 * Handles all the GC stuff so GFM doesn't complain, but does so in a programmer-friendly way
 * Sound itself gets GCed, but will make sure to delete the SDLSample once the sample is finished
 */
module graphics.Sound;

import std.conv;
import std.string;
import gfm.sdl2;

/**
 * All sound effects
 */
enum Effect{
    TODO
}

/**
 * All music
 */
enum Music{
    SpinningSong
}

int sfxVolume = 80;       ///The volume for the sound effects; can be altered by other threads
int musicVolume = 100;    ///The volume for the music; can be altered by other threads

/**
 * An interface that is made just to abstract a Sound to a common superclass so that sounds can be stored regardless of template parameter
 */
abstract class Sample{
    string id;          ///The name of the sample
    bool isFinished;    ///Whether the sample is done playing or not
    void tick();        ///What the sample does every turn; should at least adjust volume
}

/**
 * A class that handles playing sound
 * Also manages destruction of SDLSample so that GFM doesn't complain but sound is easy to make and use
 * Is templated to either play a Music or an Effect
 */
class Sound(T) if(is(T == Effect) || is(T == Music)): Sample{

    SDLMixer musicCreator;  ///The SDL utility object that actually plays this sound
    SDLSample actualSound;  ///The actual SDLSample that this sound will play and work on
    int channel;            ///The channel on which this sound is playing

    /**
     * Constructs a sound object given what sound to play, the object to create the sound, and how many times to play it (negative times to play it loops it infinitely)
     * Automatically determines whether the sound is an effect or a music, and adjusts for volume and other things accordingly
     */
    this(T sound, SDLMixer musicCreator, int numTimes = 1){
        this.id = sound.to!string;
        this.actualSound = new SDLSample(musicCreator, "res/sounds/" ~ __traits(identifier, T).toLower() ~ "/" ~ sound.to!string ~ ".wav");
        this.channel = this.actualSound.play(-1, numTimes);
    }

    /**
     * Ensures that the SDLSample gets destroyed if this sound gets destroyed so GFM doesn't complain
     */
    ~this(){
        this.actualSound.destroy();
    }

    /**
     * Destroys the SDLSample if the sound is over
     * Also adjusts the volume such that it is consistent with the global volume variables
     */
    override void tick(){
        this.actualSound.setVolume((is(T == Effect))? sfxVolume : musicVolume);
        if(this.isFinished){
            this.actualSound.destroy();
            return;
        }
    }

}