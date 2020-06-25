// ---------------- Initialisation ----------------
final double ent_speedStep = 0.15;

//turtles
final int turtle_parent_hitboxX = 72;
final int turtle_parent_hitboxY = 48;
final int turtle_child_hitboxX  = 48;
final int turtle_child_hitboxY  = 32;



// ----------------- Classes -----------------
class turtle{
    
    //attributes
    boolean parent = false;
    float x,y;
    boolean right = true;
    double vectorX = 0;
    double vectorY = 0;
    double speed = 0;
    double distance; //distance to mother
    
    //methods
    turtle(float x, float y, double d){
        this.x = x;
        this.y = y;
        this.distance = d;
    }
    
    void tryMove(float newX, float newY){
        
        //set hitbox x interval
        int minX,maxX;
        if(this.parent){
            minX = (int)newX-turtle_parent_hitboxX;
            maxX = (int)newX+turtle_parent_hitboxX;
        }else{
            minX = (int)newX-turtle_child_hitboxX;
            maxX = (int)newX+turtle_child_hitboxX;
        }
        if(minX < 0)
            minX = 0;
        if(maxX > width)
            maxX = width;
        
        //set hitbox y interval
        int maxY;
        if(this.parent)
            maxY = (int)newY+turtle_parent_hitboxY;
        else
            maxY = (int)newY+turtle_child_hitboxY;
        if(maxY > height)
            maxY = height;
        
        //check on whole interval
        boolean ok = true;
        for(int x=minX; x < maxX; x++){
            if(maxY > height-ground_height[ground_deltaX+x])
                ok = false;
        }
        if(!ok)
            return;
        this.x = newX;
        this.y = newY;
    }
    
    void update(){
        
        //move following vector
        double coef = this.speed*0.001/2;
        if(coef > 0.3)
            coef = 0.3;
        this.tryMove(
            (float)( this.x + this.vectorX * coef),
            (float)( this.y + this.vectorY * coef)
        );
        this.speed -= ent_speedStep;
        
        //correct speed
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
        if(this.parent){
            if(this.right)
                image(img_turtle_parent_right,this.x-turtle_parent_hitboxX,this.y-turtle_parent_hitboxY);
            else
                image(img_turtle_parent_left,this.x-turtle_parent_hitboxX,this.y-turtle_parent_hitboxY);
        }else{
            if(this.right)
                image(img_turtle_child_right,this.x-turtle_child_hitboxX,this.y-turtle_child_hitboxY);
            else
                image(img_turtle_child_left,this.x-turtle_child_hitboxX,this.y-turtle_child_hitboxY);
        }
    }
}
