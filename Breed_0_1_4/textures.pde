// ----------------- Initialisation -----------------
//background
PImage img_sky;

//ground
PImage[] img_shell  = new PImage[4];
PImage[] img_fossil = new PImage[3];

//entities
//player
PImage img_turtle_adult_right;
PImage img_turtle_adult_left;
PImage img_turtle_child_right;
PImage img_turtle_child_left;
PImage img_shark_right;
PImage img_shark_left;
PImage img_mask_adult_right;
PImage img_mask_adult_left;
PImage img_mask_child_right;
PImage img_mask_child_left;
PImage img_katana_right;
PImage img_katana_left;
//hostiles
PImage[] img_can        = new PImage[2];
PImage[] img_plasticBag = new PImage[2];
//passives
PImage[] img_crab   = new PImage[2];
PImage[][] img_fish = new PImage[3][2];
PImage img_sharkFish_left;
PImage img_sharkFish_right;

//particles
PImage[] img_bubbles = new PImage[5];

//User Interface
PImage img_startMenu;
PImage img_endMenu;
PImage[] img_sound = new PImage[2];
PImage img_mouse;



// ------------------- Execution --------------------
void initTextures(){
    //background
    img_sky = loadImage("sprites/sky.bmp");
    
    //ground
    for(byte a=0; a < img_shell.length; a++)
        img_shell[a] = loadImage("sprites/ground/shell" + a + ".png");
    for(byte a=0; a < img_fossil.length; a++)
        img_fossil[a] = loadImage("sprites/ground/fossil" + a + ".png");
    
    //entities
    //player
    img_turtle_adult_right = loadImage("sprites/entities/turtle_adult_right.png");
    img_turtle_adult_left  = loadImage("sprites/entities/turtle_adult_left.png" );
    img_turtle_child_right = loadImage("sprites/entities/turtle_child_right.png");
    img_turtle_child_left  = loadImage("sprites/entities/turtle_child_left.png" );
    img_shark_right        = loadImage("sprites/entities/shark_right.png"       );
    img_shark_left         = loadImage("sprites/entities/shark_left.png"        );
    img_mask_adult_right   = loadImage("sprites/entities/mask_adult_right.png"  );
    img_mask_adult_left    = loadImage("sprites/entities/mask_adult_left.png"   );
    img_mask_child_right   = loadImage("sprites/entities/mask_child_right.png"  );
    img_mask_child_left    = loadImage("sprites/entities/mask_child_left.png"   );
    img_katana_right       = loadImage("sprites/entities/katana_right.png"      );
    img_katana_left        = loadImage("sprites/entities/katana_left.png"       );
    
    //hostiles
    for(byte a=0; a < img_can.length; a++)
        img_can[a] = loadImage("sprites/entities/can" + a + ".png");
    for(byte a=0; a < img_plasticBag.length; a++)
        img_plasticBag[a] = loadImage("sprites/entities/plasticBag" + a + ".png");
    
    //passives
    for(byte a=0; a < img_crab.length; a++)
        img_crab[a] = loadImage("sprites/entities/crab" + a + ".png");
    for(byte a=0; a < img_fish.length; a++){
        img_fish[a][0] = loadImage("sprites/entities/fish" + a + "_left.png" );
        img_fish[a][1] = loadImage("sprites/entities/fish" + a + "_right.png");
    }
    img_sharkFish_left  = loadImage("sprites/entities/sharkFish_left.png" );
    img_sharkFish_right = loadImage("sprites/entities/sharkFish_right.png");
    
    //particles
    for(byte a=0; a < img_bubbles.length; a++)
        img_bubbles[a] = loadImage("sprites/particles/bubble" + a + ".png");
    
    //User Interface
    img_startMenu = loadImage("sprites/UI/startMenu.png");
    img_endMenu   = loadImage("sprites/UI/endMenu.png"  );
    img_sound[0] = loadImage("sprites/UI/sound_off.png");
    img_sound[1] = loadImage("sprites/UI/sound_on.png" );
    img_mouse = loadImage("sprites/UI/cursor.png");
}
