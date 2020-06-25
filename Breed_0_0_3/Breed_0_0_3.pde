/* ================== Breed [0.0.3] =================
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
    
    TO DO : - Spawn enemies
            - Make turtles grow
    
    BUGS : - Terrain is black instead of brown-orange
           - Terrain generation is brutal between lands

   ================================================== */



// ---------------- Importations ----------------
import ddf.minim.*;



// ---------------- Initialisation ----------------
//functional vars
final short WIDTH  = 1280;   //window spec
final short HEIGHT = 480;
final short width_2   = 640;
final short height_2  = 240;
final short height_4  = 120;
final short height_8  = 60;
final short height_12 = 40;

//game vars
enum menu_names{
    START,
    GAME
};
menu_names menu = menu_names.START;
int timedUpdate;
int screenshotNbr;
/*
final float PIdiv2 = PI/2;
final float PImul2 = 2*PI;
*/

//entities
turtle mother;
byte CHILDREN_LENGTH = 8;
turtle[] children = new turtle[CHILDREN_LENGTH];

//setup
void setup(){
    
    //functional
    size(1280,480,P2D);
    stroke(0);
    strokeWeight(1);
    scale(0.5);
    initTextures();
    initSounds();
    cursor(img_mouse);
    frameRate(50);
    
    //ground generation
    initGround();
    
    //entities
    mother = new turtle(width_2,height_2/2,0);
    mother.parent = true;
    for(byte c=0; c < CHILDREN_LENGTH; c++)
        children[c] = new turtle(
            width_2  + random(50),
            height_2/2 + random(50),
            c
        );
}



// ---------------- Execution ----------------
void draw(){
    
    //events update
    timedEvents();
    display();
    
    //timed updates
    timedUpdate++;
    if(timedUpdate == 2000){
        soundCheck();
        timedUpdate = 0;
    }
}
