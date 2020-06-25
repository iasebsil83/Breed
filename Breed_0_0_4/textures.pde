// -------------------- Initialisation --------------------
PImage img_sky; //textures
PImage img_turtle_adult_right;
PImage img_turtle_adult_left;
PImage img_turtle_child_right;
PImage img_turtle_child_left;
PImage img_startMenu;  //User Interface
PImage img_endMenu;
PImage[] img_sound = new PImage[2];
PImage img_mouse;

void initTextures(){
    //textures
    img_sky = loadImage("sprites/sky.bmp");
    img_turtle_adult_right = loadImage("sprites/turtle_adult_right.png");
    img_turtle_adult_left  = loadImage("sprites/turtle_adult_left.png");
    img_turtle_child_right  = loadImage("sprites/turtle_child_right.png");
    img_turtle_child_left   = loadImage("sprites/turtle_child_left.png");
    
    //User Interface
    img_startMenu = loadImage("sprites/UI/startMenu.png");
    img_endMenu = loadImage("sprites/UI/endMenu.png"    );
    img_sound[0] = loadImage("sprites/UI/sound_off.png");
    img_sound[1] = loadImage("sprites/UI/sound_on.png" );
    img_mouse = loadImage("sprites/UI/cursor.png");
}
