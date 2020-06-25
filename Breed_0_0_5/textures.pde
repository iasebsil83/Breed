// ----------------- Initialisation -----------------
//background
PImage img_sky;

//ground
PImage[] img_shell;
PImage[] img_fossil;

//entities
//player
PImage img_turtle_adult_right;
PImage img_turtle_adult_left;
PImage img_turtle_child_right;
PImage img_turtle_child_left;
//hostiles
PImage img_can;
PImage img_crushedCan;
PImage[] img_plasticBag;
//passives
PImage img_crab;
PImage[] img_fish;

//User Interface
PImage img_startMenu;
PImage img_endMenu;
PImage[] img_sound;
PImage img_mouse;



// ------------------- Execution --------------------
void initTextures(){
    //background
    img_sky = loadImage("sprites/sky.bmp");
    
    //ground
    img_shell = new PImage[4];
    for(byte a=0; a < 4; a++)
        img_shell[a] = loadImage("sprites/ground/shell" + a + ".png");
    img_fossil = new PImage[2];
    img_fossil[0] = loadImage("sprites/ground/fossil0.png");
    img_fossil[1] = loadImage("sprites/ground/fossil1.png");
    
    //entities
    //player
    img_turtle_adult_right = loadImage("sprites/entities/turtle_adult_right.png");
    img_turtle_adult_left  = loadImage("sprites/entities/turtle_adult_left.png" );
    img_turtle_child_right = loadImage("sprites/entities/turtle_child_right.png");
    img_turtle_child_left  = loadImage("sprites/entities/turtle_child_left.png" );
    //hostiles
    img_can        = loadImage("sprites/entities/can.png"       );
    img_crushedCan = loadImage("sprites/entities/crushedCan.png");
    img_plasticBag = new PImage[2];
    img_plasticBag[0] = loadImage("sprites/entities/plasticBag0.png");
    img_plasticBag[1] = loadImage("sprites/entities/plasticBag1.png");
    //passives
    img_crab = loadImage("sprites/entities/crab.png");
    img_fish = new PImage[3];
    for(byte a=0; a < 3; a++)
        img_fish[a] = loadImage("sprites/entities/fish" + a + ".png");
    
    //User Interface
    img_startMenu = loadImage("sprites/UI/startMenu.png");
    img_endMenu = loadImage("sprites/UI/endMenu.png"    );
    img_sound = new PImage[2];
    img_sound[0] = loadImage("sprites/UI/sound_off.png");
    img_sound[1] = loadImage("sprites/UI/sound_on.png" );
    img_mouse = loadImage("sprites/UI/cursor.png");
}
