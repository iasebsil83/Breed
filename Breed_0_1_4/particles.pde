// ---------------- Initialisation ----------------
//bubbles
final int bubbles_cntMax = 80;
final int bubbles_riseSpeed = 1;
//fire
final int fire_riseSpeed = 30;
final int fire_maxHeight = 60;
final float fire_centerization = 0.9;
final float fire_redRate          = 20;
final float fire_orangeYellowRate = 40;
enum fireType{
    RED,
    ORANGE,
    YELLOW
};



// ---------------- Functions ----------------
//fire
void showFire(Fire[] frag, int dx){
    //red fragments
    for(int f=0; f < frag.length; f++){
        if(frag[f].type == fireType.RED){
            fill(255,0,0);
            rect(dx+frag[f].x, frag[f].y, 2,2);
        }
    }
    //orange fragments
    for(int f=0; f < frag.length; f++){
        if(frag[f].type == fireType.ORANGE){
            fill(255,100,80);
            rect(dx+frag[f].x, frag[f].y, 2,2);
        }
    }
    //yellow fragments
    for(int f=0; f < frag.length; f++){
        if(frag[f].type == fireType.YELLOW){
            fill(255,255,0);
            rect(dx+frag[f].x, frag[f].y, 2,2);
        }
    }
}



// ---------------- Classes ----------------
class Bubble{
    
    //attributes
    float x,y;
    int cnt = 0;
    int nbr = 0;
    
    //methods
    void activate(float x, float y){
        this.x = x;
        this.y = y;
        this.cnt = bubbles_cntMax;
        this.nbr = (int)random(5);
    }
    
    void update(){
        //spending lifetime of a bubble
        cnt--;
        
        //movement
        this.y -= bubbles_riseSpeed;
        if(this.y < height_8)
            this.cnt = 0;
    }
    
    void show(int dx){
        //bubble
        image(img_bubbles[this.nbr], dx+this.x, this.y);
    }
    
    void setAttributesFrom(Bubble b){
        this.x = b.x;    this.y = b.y;
        this.cnt = b.cnt;
        this.nbr = b.nbr;
    }
}

class Fire{
    
    //attributes
    float x    = 0;    float y    = 0;
    float minY = 0;    float maxY = 0;
    fireType type;
    
    //methods
    Fire(float x, float y, byte hitboxX, byte hitboxY){
        //set type
        if(random(100) > fire_redRate)
            this.type = fireType.RED;
        else if(random(100) > fire_orangeYellowRate)
            this.type = fireType.ORANGE;
        else
            this.type = fireType.YELLOW;
        this.update(x,y, hitboxX,hitboxY);
    }
    
    void update(float x, float y, byte hitboxX, byte hitboxY){
        //movement
        this.x += (int)random(3)-1;
        this.y -= random(fire_riseSpeed)/9;
        
        //restart fragment to the base
        if(this.y < this.minY){
            //set new x and y coordinates
            this.x = x - hitboxX*fire_centerization + random(2*hitboxX*fire_centerization);
            this.y = y                              + random(  hitboxY*fire_centerization);
            this.maxY = this.y;
            this.minY = this.maxY - fire_maxHeight + random(4)-2;
        }
    }
    
    void setAttributesFrom(Fire f){
        this.x = f.x;          this.y = f.y;
        this.minY = f.minY;    this.maxY = f.maxY;
        this.type = f.type;
    }
}
