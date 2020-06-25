// -------------------- Initialisation --------------------
PImage img_background; //textures
PImage img_turtle_parent_right;
PImage img_turtle_parent_left;
PImage img_turtle_child_right;
PImage img_turtle_child_left;
PImage img_startMenu;  //User Interface
PImage[] img_sound = new PImage[2];
PImage img_mouse;

void initTextures(){
    //textures
    img_background = loadImage("sprites/background.bmp");
    img_turtle_parent_right = loadImage("sprites/turtle_parent_right.png");
    img_turtle_parent_left  = loadImage("sprites/turtle_parent_left.png");
    img_turtle_child_right  = loadImage("sprites/turtle_child_right.png");
    img_turtle_child_left   = loadImage("sprites/turtle_child_left.png");
    
    //User Interface
    img_startMenu = loadImage("sprites/UI/startMenu.png");
    img_sound[0] = loadImage("sprites/UI/sound_off.png");
    img_sound[1] = loadImage("sprites/UI/sound_on.png");
    img_mouse = loadImage("sprites/UI/cursor.png");
}
