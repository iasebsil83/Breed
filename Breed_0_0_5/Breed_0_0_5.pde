/* ================== Breed [0.0.5] =================
    Breed is a 2D game.
    
    Thanks for downloading ! Now, enjoy !
    
    This game is made for ISEN Challenge 2020
    ISEN Challenge is an association of the ISEN Toulon,
    an Yncrea Mediterranee engineering school :
                        www.isen.fr
    
    Please report any bug at : i.a.sebsi83@gmail.com
    
                                            By I.A.
   
    21/02/2020 > [0.0.1] :
        - Basic code structure
        - Orientation of turtles
        - Implementation of turtle movements (mother + children)
        - Use of temporar turtle sprites (not copylefted)
        - Generation of the start terrain randomly
        - Hitbox collisions for turtles added
    
    21/02/2020 > [0.0.2] :
        - World's generation until fixed limit
        
    03/03/2020 > [0.0.3] :
        - World's infinite generation
    
    04/03/2020 > [0.0.4] :
        - Turtles grow (with age), becomeParent & die
        - Children turtles become mother if she died
        - End menu
        - Terrain color bug fixed
        - Sky and water background
        - Water movement on the surface
        - Oxygen & life on turtles (execution & display)
        - Show age, oxygen and life gauges over turtles
    
    04/03/2020 > [0.0.5] :
        - Added musics and sounds- Added musics and sounds
        - Added ground elements (textures + land files)
    
    TO DO : - Enlarge a bit the shrimp fossil sprite
            - Spawn bad and good entities
            - Make mother turtle eat with right click (if adult)
            - Particles floating randomly in water
            - Day-night cycle
    
    BUGS : - Terrain generation is brutal between lands
           - Children rush to the surface is not working

   ================================================== */



// ---------------- Importations ----------------
import ddf.minim.*;



// ---------------- Initialisation ----------------
//functional vars
final short WIDTH  = 1280;   //window spec
final short HEIGHT = 700;
final short width_2   = WIDTH/2;
final short height_2  = HEIGHT/2;
final short height_4  = HEIGHT/4;
final short height_8  = HEIGHT/8;
final short height_12 = HEIGHT/12;
final short height_24 = HEIGHT/24;
final short height_48 = HEIGHT/48;
final short h_height_12 = HEIGHT - height_12;

//game vars
enum menu_names{
    START,
    GAME,
    END
};
menu_names menu = menu_names.START;
int timedUpdate;
int screenshotNbr;
final float PIdiv2 = PI/2;
final float PImul2 = 2*PI;

//entities
turtle mother;
byte CHILDREN_LENGTH = 8;
turtle[] children = new turtle[CHILDREN_LENGTH];

//settings
void settings(){
    size(WIDTH,HEIGHT,P2D);
}

//setup
void setup(){
    
    //functional
    surface.setSize(WIDTH,HEIGHT);
    surface.setTitle("Breed[0.0.5]");
    noStroke();
    initTextures();
    initSounds();
    cursor(img_mouse);
    
    //game initialization
    initGround();
    initTurtles();
}



// ---------------- Execution ----------------
void draw(){
    timedEvents();
    display();
}
