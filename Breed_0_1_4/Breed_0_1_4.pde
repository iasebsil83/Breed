/* ================== Breed [0.1.4] =================
    Breed is an 2D adventure-like game in wich you are
    a lonely turtle in the vast area of our oceans
    trying to live among all the people already there.
    
    Discover new landscapes through the movements of
    the waves under the surface, swim between sharks
    and fishes to survive and live as free as possible !
    
    Hmmm...    Actually, there's a problem in these
    waters. Seems like humans are laying their stuff
    everywhere over the oceans. Not a good deal to
    use it as food for your children ! Better destroy it
    yourself and protect our lands !
    
    Now, your mission if you accept it : clean our
    earth from the threatened activity of humans,
    and prepare a better future for your children.
    
    Good luck sea protector !
    
    Thanks for downloading ! Now, enjoy !
    
    This game is made for ISEN Challenge 2020
    ISEN Challenge is an association of the ISEN Toulon,
    an Yncrea Mediterranee engineering school :
                        www.isen.fr
    
    Contact     : i.a.sebsil83@gmail.com
    Youtube     : https://www.youtube.com/user/IAsebsil83
    GitHub repo : https://github.com/iasebsil83

    Let's Code !                                  By I.A.
   
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
    
    09/03/2020 > [0.1.0] :
        - Modification of entities structure (classes & methods)
        - Added explosion effect for entities when they died
        - Children turtles set to calmer random movements
        - Spawn bad and good entities
        - Sea grass generation and movement
        - Entities movement adjusted and simplified (tryMove())
        - Mother turtle can now :
              eat passives
              kill/(be hurt by) hostiles
          with right click (if adult)
        - Fixed children rush to the surface
    
    11/03/2020 > [0.1.1] :
        - Adult children auto attack detected hostile entities
          and passive entities only if health under maximum
        - Update only entities inside the game window
        - Fixed explosion residues floating over killed entities
        - Finished turtle attack animation
    
    14/03/2020 > [0.1.2] :
        - Sounds for turtle attack, loose life, screenshot
          and permanent water movements
        - Entities can now only spawn out of the screen
        - Score display in game and end menus
        - Randomly spawn children (very rare)
        - Particles system (including only bubbles)
        - Bubbles out of the mouth of living entities
    
    16/03/2020 > [0.1.3] :
        - Fire particles
        - Fire fish and shark masked fish spawn and sprites
        - Bubbles + ambient sounds
        - All sounds remastered
        - Fire effect on mother (particlesa and speed in
          random moves and terrain scroll)
        - Shark effect (transfomation and automatic kill all)
        - Hidden functionalities

    17/03/2020 > [0.1.4] :
        - Sound desactivation affects all kinds of sound in game
        - Fixed score and best score display in GAME and END menus
        - Fixed fire particles appearing at the wrong place
          at the beginning of effect (turtle_fireCntMax_waitTime)
        - Generation is now depending on the biome
          (one biome per land, check setMiscellaneous() for details)
        - Seagrass set at 0 are no longer displayed
    
    TO DO : - Fire, explosion, fire and shark transformation sounds
            - Particles floating randomly in water
            - Petrol lakes, volcanos generation (maybe biomes)
    
    BUGS : - Terrain generation is brutal between lands
           - Entities disapeared or are rightshifted between lands
******************************************************************************************

    LICENCE :

    Library : Breed
    Copyright (C) 2020  Sebastien SILVANO
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.

    If not, see <https://www.gnu.org/licenses/>.

   ================================================== */



// ---------------- Importations ----------------
import ddf.minim.*;



// ---------------- Functions ----------------
boolean inZone(int xp, int yp, int xm, int ym, int xM, int yM){
    return xp >= xm && xp <= xM && yp >= ym && yp <= yM;
}



// ---------------- Initialisation ----------------
//functional vars
//frame rate
final float fps = 50.0;
//window dimensions
final short WIDTH  = 1280;
final short HEIGHT = 700;
final short width_2   = WIDTH/2;
final short height_2  = HEIGHT/2;
final short height_4  = HEIGHT/4;
final short height_8  = HEIGHT/8;
final short height_12 = HEIGHT/12;
final short height_24 = HEIGHT/24;
final short height_48 = HEIGHT/48;
final short h_height_12 = HEIGHT - height_12;
//PI
final float PImul2 = 2*PI;
final float PIdiv2 = PI/2;

//game vars
//menu
enum menu_names{
    START,
    GAME,
    END
};
menu_names menu = menu_names.START;
//score
int score = 0;
int bestScore = 0;
//screenshots
int screenshotNbr;
//default entities (player)
Turtle mother;
final byte childrenLen = 8;
Turtle[] children = new Turtle[childrenLen];

//settings
void settings(){
    size(WIDTH,HEIGHT,P2D);
}

//setup
void setup(){
    
    //functional
    surface.setSize(WIDTH,HEIGHT);
    surface.setTitle("Breed[0.1.4]");
    frameRate(fps);
    noStroke();
    initTextures();
    initSounds();
    initDisplay();
    cursor(img_mouse);
    
    //game initialization
    initGround();
    initTurtles();
    initEntities();
    initSeagrass();
}



// ---------------- Execution ----------------
void draw(){
    timedEvents();
    display();
}
