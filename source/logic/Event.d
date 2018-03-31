module logic.Event;

import std.datetime;

/**
 * A struct that defines what is going on in the game
 */
struct Event {

    immutable string tag; ///What generally the event is
    immutable string message; ///What the event is
    immutable bool outwardlyVisible; ///Whether the event should be seen by the player
    immutable SysTime timestamp; ///When the event happened
    bool consumed; ///Whether the event was consumed or used up or not

    /**
     * Initializes an event with the given message
     */
    this(string tag, string message, bool outwardlyVisible = false) {
        this.tag = tag;
        this.message = message;
        this.outwardlyVisible = outwardlyVisible;
        this.timestamp = Clock.currTime;
    }

    /**
     * The string representation of the event is its message
     */
    string toString() {
        return message;
    }

}
