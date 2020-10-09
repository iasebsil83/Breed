// ---------------- Initialisation ----------------
//hitboxes
final byte turtle_adult_hitboxX = 70;
final byte turtle_adult_hitboxY = 46;
final byte turtle_child_hitboxX  = 46;
final byte turtle_child_hitboxY  = 30;
final byte turtle_shark_hitboxX  = 127;
//children
final int turtle_distance2mother = 60;
final double turtle_childSpeed = 0.0001;
final float turtle_childrenSpeed = 0.00046;
//age
final int turtle_age2becomeAdult = 2000;
final int turtle_age2die = 7000;
//oxygen
final int turtle_oxygen_max = 3000;
final int turtle_oxygen_min = 400;
final int turtle_oxygen_breath = 18;
final float turtle_breathAccelerator = 0.7;
//survival
final short turtle_lifeMax = 500;
final short turtle_lifeStep_regen = 50;
final short turtle_lifeStep_loose = 1;
final int turtle_attackCntMax = 10;
//particles
final byte turtle_bubblesMax = 50;     //bubbles
final float turtle_bubbleRate = 99.89;
final int turtle_fireCntMax = 800;     //fire
final int turtle_fireCntMax_waitTime = 45;
final int turtle_fireFragNbr = 3200;
final int turtle_sharkCntMax = 1100;    //shark



// ---------------- Functions ----------------
void initTurtles(){
    //set mother
    mother = new Turtle(
        width_2,height_2/2,
        0, turtle_age2becomeAdult
    );
    mother.adult = true;
    
    //set children
    for(byte c=0; c < childrenLen; c++){
        children[c] = new Turtle(
            0,0,0,0
        );
        children[c].alive = false;
    }
    
    //set score
    score = 0;
}

boolean detectCollision(
    float x1, float y1, byte hitboxX1, byte hitboxY1,
    float x2, float y2, byte hitboxX2, byte hitboxY2
){
    int xm1 = (int)(x1-parseInt(hitboxX1)); int ym1 = (int)(y1-parseInt(hitboxY1));
    int xM1 = (int)(x1+parseInt(hitboxX1)); int yM1 = (int)(y1+parseInt(hitboxY1));
    int xm2 = (int)(x2-parseInt(hitboxX2)); int ym2 = (int)(y2-parseInt(hitboxY2));
    int xM2 = (int)(x2+parseInt(hitboxX2)); int yM2 = (int)(y2+parseInt(hitboxY2));
    return
        inZone(xm2,ym2, xm1,ym1,xM1,yM1) ||
        inZone(xM2,ym2, xm1,ym1,xM1,yM1) ||
        inZone(xM2,yM2, xm1,ym1,xM1,yM1) ||
        inZone(xm2,yM2, xm1,ym1,xM1,yM1)
    ;
}

boolean spawnChildTurtle(){
    for(byte c=0; c < childrenLen; c++){
        if(!children[c].alive){
            //spawn on left or right of the screen
            if(random(1) > 0.5)
                children[c] = new Turtle(
                    width,
                    height_8 + random(height-height_8),
                    random(10), 0
                );
            else
                children[c] = new Turtle(
                    0,
                    height_8 + random(height-height_8),
                    random(10), 0
                );
            return true;
        }
    }
    return false;
}



// ----------------- Class -----------------
class Turtle extends Entity{
    
    //attributes
    //basics
    boolean adult = false;
    double distance; //distance to mother
    int age;
    int oxygen = turtle_oxygen_max;
    short life = turtle_lifeMax;
    int attackCnt = 0;
    //bubbles
    Bubble[] air = new Bubble[turtle_bubblesMax];
    //fire
    int fireCnt = 0;
    Fire[] fireFrag = new Fire[turtle_fireFragNbr];
    //shark
    int sharkCnt = 0;
    
    
    
    //methods
    Turtle(float x, float y, double d, int age){
        //basic initialization
        this.x = x;
        this.y = y;
        this.distance = d;
        this.age = age;
        
        //bubbles init
        for(byte b=0; b < turtle_bubblesMax; b++)
            this.air[b] = new Bubble();
        
        //fire init
        for(int f=0; f < turtle_fireFragNbr; f++)
            this.fireFrag[f] = new Fire(
                this.x,this.y,
                turtle_child_hitboxX, turtle_child_hitboxY
            );
    }
    
    
    
    void update(){
        
        //don't update dead children
        if(!this.alive)
            return;
        
        //grow
        if(!enable_a)
            this.age++;
        if(age > turtle_age2becomeAdult)
            this.adult = true;
        if(age > turtle_age2die)
            this.explode();
        
        //oxygen
        if(this.y > 3*height_8/2 && this.sharkCnt == 0)
            this.oxygen--;
        else{
            if(this.oxygen < turtle_oxygen_max){
                this.oxygen += turtle_oxygen_breath; //oxygen can have turtle_oxygen_max+turtle_oxygen_breath-1
                //breath sound
                if(!snd_breath.isPlaying() && snd_on && this.sharkCnt == 0)
                    snd_play(snd_breath);
            }
        }
        if(this.oxygen < 0){
            this.oxygen = 0;
            this.life--;
        }
        
        //low breath => rush to the surface
        if(this.oxygen < turtle_oxygen_min){
            this.vectorX = 0;
            this.vectorY = -turtle_breathAccelerator*this.y;
            this.speed += 3*ent_speedStep;
        }
        
        //life
        if(this.life < turtle_lifeMax && enable_l)
            this.life = turtle_lifeMax;
        if(this.life <= 0)
            this.explode();
        
        //attack
        if(attackCnt > 0)
            attackCnt--;
        
        //movements
        double coef = this.calcMoveCoef();
        if(this.adult)
            this.tryMove(
                (int)(this.x + this.vectorX * coef),
                (int)(this.y + this.vectorY * coef),
                turtle_adult_hitboxX, turtle_adult_hitboxY
            );
        else
            this.tryMove(
                (int)(this.x + this.vectorX * coef),
                (int)(this.y + this.vectorY * coef),
                turtle_child_hitboxX, turtle_child_hitboxY
            );
        
        //detection
        this.detectEntities();
        
        //bubbles
        if(this.sharkCnt == 0)
            this.updateBubbles();
        
        //fire
        if(this.fireCnt > 0){
            if(!enable_f)
                this.fireCnt--;
            this.speed += 2*ent_speedStep;
            if(this.sharkCnt > 0){
                for(int f=0; f < turtle_fireFragNbr; f++)
                    this.fireFrag[f].update(
                        this.x, this.y,
                        turtle_shark_hitboxX, turtle_adult_hitboxY
                    );
            }else if(this.adult){
                for(int f=0; f < turtle_fireFragNbr; f++)
                    this.fireFrag[f].update(
                        this.x, this.y,
                        turtle_adult_hitboxX, turtle_adult_hitboxY
                    );
            }else{
                for(int f=0; f < turtle_fireFragNbr; f++)
                    this.fireFrag[f].update(
                        this.x, this.y,
                        turtle_child_hitboxX, turtle_child_hitboxY
                    );
            }
        }
        
        if(this.sharkCnt > 0 && !enable_s)
            this.sharkCnt--;
        
        //entity update
        this.entityUpdate();
    }
    
    
    
    void show(){
        //explosion
        if(this.explosionCnt > 0){
            fill(0,180,0);
            for(byte d=0; d < ent_explosionDivs; d++)
                rect(this.explosionX[d]-2,this.explosionY[d]-2, 2,2);
            return;
        }
        
        //fire
        if(this.fireCnt > 0 && this.fireCnt < turtle_fireCntMax-turtle_fireCntMax_waitTime)
            showFire(this.fireFrag,0);
        
        //turtle with gauges
        if(this.adult){
            float tempX;
            float tempY = this.y-turtle_adult_hitboxY;
            if(this.sharkCnt > 0){
                //shark
                tempX = this.x-turtle_shark_hitboxX/2;
                if(this.right)
                    image(img_shark_right, this.x-turtle_shark_hitboxX,this.y-turtle_adult_hitboxY);
                else
                    image(img_shark_left,  this.x-turtle_shark_hitboxX,this.y-turtle_adult_hitboxY);
            }else{
                //turtle
                tempX = this.x-turtle_adult_hitboxX/2;
                if(this.right)
                    image(img_turtle_adult_right, this.x-turtle_adult_hitboxX,this.y-turtle_adult_hitboxY);
                else
                    image(img_turtle_adult_left,  this.x-turtle_adult_hitboxX,this.y-turtle_adult_hitboxY);
                
                //ninja
                if(enable_n){
                    nShakeColor();
                    tint(nRed,nGreen,nBlue);
                    if(this.right){
                        image(img_mask_adult_right, this.x-turtle_adult_hitboxX, this.y-turtle_adult_hitboxY);
                        tint(255,255,255);
                        image(img_katana_right, this.x-turtle_adult_hitboxX, this.y-turtle_adult_hitboxY);
                    }else{
                        image(img_mask_adult_left, this.x-turtle_adult_hitboxX, this.y-turtle_adult_hitboxY);
                        tint(255,255,255);
                        image(img_katana_left, this.x-turtle_adult_hitboxX, this.y-turtle_adult_hitboxY);
                    }
                }
            }
            //age gauge
            fill(105,105,105);
            rect(tempX,tempY-8, turtle_adult_hitboxX,5);
            fill(205,205,205);
            rect(tempX,tempY-8, this.age*turtle_adult_hitboxX/turtle_age2die,5);
            
            //oxygen gauge
            fill(105,125,235);
            rect(tempX,tempY, turtle_adult_hitboxX,5);
            fill(155,225,255);
            rect(tempX,tempY, this.oxygen*turtle_adult_hitboxX/turtle_oxygen_max,5);
            
            //life gauge
            fill(195,0,0);
            rect(tempX,tempY+8, turtle_adult_hitboxX,5);
            fill(255,0,0);
            rect(tempX,tempY+8, this.life*turtle_adult_hitboxX/turtle_lifeMax,5);
            
            //attack
            if(this.attackCnt > 0){
                fill(210,210,210);
                if(this.right){
                    //attack animation
                    float coef = 1.0-(float)this.attackCnt/turtle_attackCntMax;
                    for(int i=0; i < coef*2*turtle_adult_hitboxY; i++)
                        rect(
                            this.x+turtle_adult_hitboxX + 7*sin(PIdiv2*i/turtle_adult_hitboxY), tempY+i,
                            7*sin(PIdiv2*i/turtle_adult_hitboxY), 1
                        );
                }else{
                    //attack animation
                    float coef = 1.0-(float)this.attackCnt/turtle_attackCntMax;
                    for(int i=0; i < coef*2*turtle_adult_hitboxY; i++)
                        rect(
                            this.x-turtle_adult_hitboxX - 7*sin(PIdiv2*i/turtle_adult_hitboxY), tempY+i,
                            -7*sin(PIdiv2*i/turtle_adult_hitboxY), 1
                        );
                }
            }
            
        }else{
            float tempX;
            float tempY = this.y-turtle_child_hitboxY;
            if(this.sharkCnt > 0){
                //shark
                tempX = this.x-turtle_shark_hitboxX/2;
                if(this.right)
                    image(img_shark_right, this.x-turtle_shark_hitboxX,this.y-turtle_adult_hitboxY);
                else
                    image(img_shark_left,  this.x-turtle_shark_hitboxX,this.y-turtle_adult_hitboxY);
            }else{
                //turtle
                tempX = this.x-turtle_child_hitboxX/2;
                if(this.right)
                    image(img_turtle_child_right, this.x-turtle_child_hitboxX,this.y-turtle_child_hitboxY);
                else
                    image(img_turtle_child_left,  this.x-turtle_child_hitboxX,this.y-turtle_child_hitboxY);
                
                //ninja
                if(enable_n){
                    nShakeColor();
                    tint(nRed,nGreen,nBlue);
                    if(this.right)
                        image(img_mask_child_right, this.x-turtle_child_hitboxX, this.y-turtle_child_hitboxY);
                    else
                        image(img_mask_child_left, this.x-turtle_child_hitboxX, this.y-turtle_child_hitboxY);
                    tint(255,255,255);
                }
            }
            
            //age gauge
            fill(105,105,105);
            rect(tempX,tempY-8, turtle_child_hitboxX,5);
            fill(205,205,205);
            rect(tempX,tempY-8, this.age*turtle_child_hitboxX/turtle_age2die,5);
            
            //oxygen gauge
            fill(105,125,235);
            rect(tempX,tempY, turtle_child_hitboxX,5);
            fill(155,225,255);
            rect(tempX,tempY, this.oxygen*turtle_child_hitboxX/turtle_oxygen_max,5);
            
            //life gauge
            fill(195,0,0);
            rect(tempX,tempY+8, turtle_child_hitboxX,5);
            fill(255,0,0);
            rect(tempX,tempY+8, this.life*turtle_child_hitboxX/turtle_lifeMax,5);
        }
        
        //bubbles
        if(this.sharkCnt == 0){
            for(byte b=0; b < turtle_bubblesMax; b++){
                if(this.air[b].cnt > 0)
                    this.air[b].show(0);
            }
        }
    }
    
    
    
    void attack(){
        //attack sound
        if(!snd_attack.isPlaying() && snd_on)
            snd_play(snd_attack);
        
        if(this.attackCnt <= 0)
            attackCnt = turtle_attackCntMax;
    }
    
    
    
    void setAttributesFrom(Turtle t){
        this.adult    = t.adult;
        this.x        = t.x;
        this.y        = t.y;
        this.right    = t.right;
        this.vectorX  = t.vectorX;
        this.vectorY  = t.vectorY;
        this.speed    = t.speed;
        this.distance = t.distance;
        this.life     = t.life;
        this.oxygen   = t.oxygen;
        this.age      = t.age;
    }
    
    
    
    void updateBubbles(){
        for(byte b=0; b < turtle_bubblesMax; b++){
            if(this.air[b].cnt > 0)
                this.air[b].update();
            else{
                if(random(100) > turtle_bubbleRate){
                    //spawn bubble
                    if(this.adult){
                        if(this.right)
                            this.air[b].activate(
                                this.x+turtle_adult_hitboxX + random(4)-2,
                                this.y                      + random(4)-2
                            );
                        else
                            this.air[b].activate(
                                this.x-turtle_adult_hitboxX + random(4)-2,
                                this.y                      + random(4)-2
                            );
                    }else{
                        if(this.right)
                            this.air[b].activate(
                                this.x+turtle_child_hitboxX + random(4)-2,
                                this.y                      + random(4)-2
                            );
                        else
                            this.air[b].activate(
                                this.x-turtle_child_hitboxX + random(4)-2,
                                this.y                      + random(4)-2
                            );
                    }
                    //bubble sound
                    if(random(1) > 0.5){
                        byte a = (byte)random(8);
                        if(!snd_bubbles[a].isPlaying() && snd_on)
                            snd_play(snd_bubbles[a]);
                    }
                    break;
                }
            }
        }
    }
    
    
    
    void detectEntities(){
        //set correct hitbox
        byte hitboxX, hitboxY;
        if(this.adult){
            hitboxX = turtle_adult_hitboxX;
            hitboxY = turtle_adult_hitboxY;
        }else{
            hitboxX = turtle_child_hitboxX;
            hitboxY = turtle_child_hitboxY;
        }
        
        //passive entities
        fill(255,255,0);
        for(int e=0; e < passive_entitiesLen; e++){
            if(passive_entities[e].explosionCnt <= 0 && detectCollision(
                this.x, this.y,
                hitboxX, hitboxY,
                passive_entities[e].x-gnd_deltaX, passive_entities[e].y,
                passive_hitboxX, passive_hitboxY
            )){
                //auto attack if children, adult state, needing food
                if(this != mother && this.adult && this.life < turtle_lifeMax)
                    this.attack();
                
                //eat passive_entities[e]
                if(this.attackCnt > 0 || this.sharkCnt > 0){
                    //kill passive
                    passive_entities[e].explode();
                    
                    //heal
                    if(this.life < turtle_lifeMax)
                        this.life += turtle_lifeStep_regen;
                    if(this.life > turtle_lifeMax) //can't tolerate life level bigger than maximum
                        this.life = turtle_lifeMax;
                    
                    //fire fish transmits power
                    if(passive_entities[e].type == passiveType.FIRE_FISH)
                        this.fireCnt = turtle_fireCntMax;
                    
                    //shark fish transmits power
                    if(passive_entities[e].type == passiveType.SHARK_FISH)
                        this.sharkCnt = turtle_sharkCntMax;
                }
                break;
            }
        }
        
        //hostile entities
        for(int e=0; e < hostile_entitiesLen; e++){
            if(hostile_entities[e].explosionCnt <= 0 && detectCollision(
                this.x, this.y,
                hitboxX, hitboxY,
                hostile_entities[e].x-gnd_deltaX, hostile_entities[e].y,
                hostile_hitboxX, hostile_hitboxY
            )){
                //auto attack if children, adult state
                if(this != mother && this.adult)
                    this.attack();
                
                //kill hostile_entities[e]
                if(this.attackCnt > 0 || this.sharkCnt > 0){
                    hostile_entities[e].explode();
                    score++;
                    break;
                }else{
                    //loose life sound
                    if(!snd_looseLife.isPlaying() && snd_on)
                        snd_play(snd_looseLife);
                    
                    this.life -= turtle_lifeStep_loose;
                }
            }
        }
    }
}
