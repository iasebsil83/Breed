/* ================== Breed [0.0.1] =================
    Breed is a 2D game.
    
    Thanks for downloading ! Now, enjoy !
    
    This game is made for ISEN Challenge 2020
    ISEN Challenge is an association of the ISEN Toulon,
    an Yncrea Mediterranee engineering school :
                        www.isen.fr
    
    Please report any bug at : i.a.sebsi83@gmail.com
    
                                            By I.A.
   
    Versions :

    21/02/2020 > [0.0.1] :
		- Basic code structure
        - Orientation of turtles
        - Implementation of turtle movements (mother + children)
		- Use of temporar turtle sprites (not copylefted)
		- Generation of the start terrain randomly
		- Hitbox collisions for turtles added
    
    TO DO : - World's infinite generation
    
    BUGS : - Terrain is black instead of brown-orange

   ================================================== */



// ---------------- Importations ----------------
import ddf.minim.*;



// ---------------- Functions ----------------
void initGround(){
    ground_color = color(230,210,200);
    ground_height = new int[width];
    int height_3 = height/3;
    int height_8 = height/8;
    int height_12 = height_3/4;
    int ground_amp = height/2;
    float ground_freq = 0.01;
    for(int x=0; x < width; x++){
        if(random(1) < 0.5)
            ground_amp++;
        else
            ground_amp--;
        if(ground_amp < height_12)
            ground_amp += 2;
        if(ground_amp > height_8)
            ground_amp -= 2;
        if(random(1) < 0.5)
            ground_freq += 0.00006;
        else
            ground_freq -= 0.00006;
        ground_height[x] = (int)( height_3 + ground_amp*cos(ground_freq*x) );
    }
    final float diff_max = 1;
    for(int x=1; x < width; x++){
        if(ground_height[x-1]-ground_height[x] > diff_max)
            ground_height[x] = (ground_height[x-1]+ground_height[x])/2;
    }
}



// ---------------- Initialisation ----------------
//functional
enum menu_names{
    START,
    GAME
};
menu_names menu = menu_names.START;
int timedUpdate;
int screenshotNbr;
final float PIdiv2 = PI/2;
final float PImul2 = 2*PI;
final short width_2  = 640;
final short height_2 = 360;

//ground
color ground_color;
int[] ground_height;

//entities
turtle mother;
byte CHILDREN_LENGTH = 8;
turtle[] children = new turtle[CHILDREN_LENGTH];

//setup
void setup(){
    
    //functional
    size(1280,720,P2D);
    stroke(0);
    strokeWeight(1);
    scale(0.5);
    initTextures();
    initSounds();
    cursor(img_mouse);
    
    //ground generation
    initGround();
    
    //entities
    mother = new turtle(width/2,height/4,0);
    mother.parent = true;
    for(byte c=0; c < CHILDREN_LENGTH; c++)
        children[c] = new turtle(
            width/2  + random(50),
            height/4 + random(50),
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
