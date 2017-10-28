module graphics.KeyMap;

import gfm.sdl2;

enum Action{
    FULLSCREEN, MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT
}

enum SDL_Keycode[Action] defaultKeyMap = [Action.FULLSCREEN : SDLK_F11, Action.MOVE_UP : SDLK_w, Action.MOVE_LEFT : SDLK_a, Action.MOVE_DOWN : SDLK_s, Action.MOVE_RIGHT : SDLK_d];
SDL_Keycode[Action] currentKeyMap;

shared static this(){
    try{
        //TODO try reading from a file or something to get keymap and put in currentKeyMap
    }catch(Exception e){
        currentKeyMap = defaultKeyMap;
    }
}
