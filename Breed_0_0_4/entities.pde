// ---------------- Initialisation ----------------
final double ent_speedStep = 0.15;

//turtles
final byte turtle_adult_hitboxX = 70;
final byte turtle_adult_hitboxY = 46;
final byte turtle_child_hitboxX  = 46;
final byte turtle_child_hitboxY  = 30;
final int turtle_distance2mother = 60;
final double turtle_childSpeed = 0.0001;
final float turtle_childrenSpeed = 0.00046;
final int turtle_age2becomeAdult = 10000;
final int turtle_age2die = 90000;
final int turtle_oxygen_max = 10000;
final int turtle_oxygen_min = 100;
final short turtle_life_max = 500;



// ---------------- Functions ----------------
void initTurtles(){
    mother = new turtle(
        width_2,height_2/2,
        0, turtle_age2becomeAdult
    );
    mother.adult = true;
    for(byte c=0; c < CHILDREN_LENGTH; c++)
        children[c] = new turtle(
            width_2  + random(50),
            height_2/2 + random(50),
            c, 0
        );
}



// ----------------- Classes -----------------
class turtle{
    
    //attributes
    boolean adult = false;
    float x,y;
    boolean right = true;
    double vectorX = 0;
    double vectorY = 0;
    double speed = 0;
    double distance; //distance to mother
    int age;
    boolean alive = true;
    int oxygen = turtle_oxygen_max;
    short life = turtle_life_max;
    
    //methods
    turtle(float x, float y, double d, int age){
        this.x = x;
        this.y = y;
        this.distance = d;
        this.age = age;
    }
    
    void tryMove(int newX, int newY){
        
        //set hitbox x interval
        int minX,maxX;
        if(this.adult){
            minX = newX-turtle_adult_hitboxX;
            maxX = newX+turtle_adult_hitboxX;
        }else{
            minX = newX-turtle_child_hitboxX;
            maxX = newX+turtle_child_hitboxX;
        }
        if(minX < 0)
            minX = 0;
        if(maxX > width)
            maxX = width;
        
        //set hitbox y interval
        int minY, maxY;
        if(this.adult){
            minY = newY-turtle_adult_hitboxY;
            maxY = newY+turtle_adult_hitboxY;
        }else{
            minY = newY-turtle_child_hitboxY;
            maxY = newY+turtle_child_hitboxY;
        }
        if(maxY > height)
            maxY = height;
        
        //check on whole interval
        boolean ok = true;
        for(int x=minX; x < maxX; x++){
            if(
                maxY > height-gnd_buffer[gnd_deltaX+x] || //ground limits
                minY < height_48 //sea surface limit
            )
                ok = false;
        }
        if(!ok)
            return;
        this.x = (4*x + newX)/5;
        this.y = (4*y + newY)/5;
    }
    
    void update(){
        //grow
        this.age++;
        if(age > turtle_age2becomeAdult)
            this.adult = true;
        if(age > turtle_age2die)
            this.alive = false;
        
        //oxygen
        if(this.y > 3*height_8/2)
            this.oxygen--;
        else{
            if(this.oxygen < turtle_oxygen_max)
                this.oxygen += 3; //oxygen can have turtle_oxygen_max+2
        }                         //(no problem currently found with that)
        if(this.oxygen < 0){
            this.oxygen = 0;
            this.life--;
        }
        
        //low breath => rush to the surface
        if(this.oxygen < turtle_oxygen_min){
            this.vectorX = 0;
            this.vectorY = -1.1*this.y;
            this.speed += ent_speedStep;
        }
        
        //life
        if(this.life <= 0)
            menu = menu_names.END;
        
        //move following vector
        double coef = this.speed*0.001/2;
        if(coef > 0.3)
            coef = 0.3;
        this.tryMove(
            (int)( this.x + this.vectorX * coef),
            (int)( this.y + this.vectorY * coef)
        );
        this.speed -= ent_speedStep;
        
        //correction of speed value
        if(this.speed < 0){
            this.speed = 0;
            return;
        }
        
        //set right attribute
        if(this.speed != 0){
            if(this.vectorX > 0)
                this.right = true;
            else
                this.right = false;
        }
    }
    
    void show(){
        if(this.adult){
            float tempX = this.x-turtle_adult_hitboxX/2;
            float tempY = this.y-turtle_adult_hitboxY;
            
            //turtle
            if(this.right)
                image(img_turtle_adult_right,this.x-turtle_adult_hitboxX,this.y-turtle_adult_hitboxY);
            else
                image(img_turtle_adult_left,this.x-turtle_adult_hitboxX,this.y-turtle_adult_hitboxY);
            
            //age gauge
            fill(105,105,105);
            rect(
                tempX,tempY-8,
                turtle_adult_hitboxX,5
            );
            fill(205,205,205);
            rect(
                tempX,tempY-8,
                this.age*turtle_adult_hitboxX/turtle_age2die,5
            );
            
            //oxygen gauge
            fill(105,125,235);
            rect(
                tempX,tempY,
                turtle_adult_hitboxX,5
            );
            fill(155,225,255);
            rect(
                tempX,tempY,
                this.oxygen*turtle_adult_hitboxX/turtle_oxygen_max,5
            );
            
            //life gauge
            fill(195,0,0);
            rect(
                tempX,tempY+8,
                turtle_adult_hitboxX,5
            );
            fill(255,0,0);
            rect(
                tempX,tempY+8,
                this.life*turtle_adult_hitboxX/turtle_life_max,5
            );
        }else{
            float tempX = this.x-turtle_child_hitboxX/2;
            float tempY = this.y-turtle_child_hitboxY;
            
            //turtle
            if(this.right)
                image(img_turtle_child_right,this.x-turtle_child_hitboxX,this.y-turtle_child_hitboxY);
            else
                image(img_turtle_child_left,this.x-turtle_child_hitboxX,this.y-turtle_child_hitboxY);
            
            //age gauge
            fill(105,105,105);
            rect(
                tempX,tempY-8,
                turtle_adult_hitboxX,5
            );
            fill(205,205,205);
            rect(
                tempX,tempY-8,
                this.age*turtle_adult_hitboxX/turtle_age2die,5
            );
            
            //oxygen gauge
            fill(105,125,235);
            rect(
                tempX,tempY,
                turtle_child_hitboxX,5
            );
            fill(155,225,255);
            rect(
                tempX,tempY,
                this.oxygen*turtle_child_hitboxX/turtle_oxygen_max,5
            );
            
            //life gauge
            fill(195,0,0);
            rect(
                tempX,tempY+8,
                turtle_child_hitboxX,5
            );
            fill(255,0,0);
            rect(
                tempX,tempY+8,
                this.life*turtle_child_hitboxX/turtle_life_max,5
            );
        }
    }
    
    void setAttributesFrom(turtle t){
        this.adult = t.adult;
        this.x = t.x;
        this.y = t.y;
        this.right   = t.right;
        this.vectorX = t.vectorX;
        this.vectorY = t.vectorY;
        this.speed   = t.speed;
        this.distance = t.distance;
        this.age = t.age;
    }
}
