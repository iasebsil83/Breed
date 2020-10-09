// ---------------- Initialisation ----------------
//hitboxes
final byte passive_hitboxX = 20;
final byte passive_hitboxY = 20;
//storage
final int passive_entitiesCap = 50;
int passive_entitiesLen = 0;
PassiveEnt[] passive_entities;
//movements
final int passive_moveCntMax = 40;
final double passive_speedMin = 100;
final double passive_speedMax = 400;
final int crab_offsetY = 50;
//types
enum passiveType{
    FIRE_FISH,
    SHARK_FISH,
    FISH,
    CRAB
};
//particles
final byte passive_bubblesNbr = 30;
final float passive_bubbleRate = 99.89;
final int passive_fireFragNbr = 50;



// ---------------- Functions ----------------
void deletePassiveEntity(int e){
    for(int p=e; p < passive_entitiesLen-1; p++)
        passive_entities[e].setAttributesFrom(passive_entities[e+1]);
    passive_entitiesLen--;
}

void spawnPassive(int x){
    //check for a dead one in the list
    int row = -1;
    for(int e=0; e < passive_entitiesLen; e++){
        if(!passive_entities[e].alive){
            row = e;
            break;
        }
    }
    //if not found
    if(row == -1)
        row = passive_entitiesLen++;
    
    //spawn cap
    if(passive_entitiesLen >= passive_entitiesCap-1){
        passive_entitiesLen--;
        return;
    }
    
    //spawn passive entity
    switch((int)random(2)){
        case 0:
            //spawn fire fish
            if(random(100) > firefish_spawnRate){
                passive_entities[row] = new PassiveEnt(
                    x,
                    (int)( height_8 + random(height-height_8-gnd_dirtBuffer[x]) ),
                    passiveType.FIRE_FISH
                );
                return;
            }
            
            //spawn shark fish
            if(random(100) > sharkfish_spawnRate){
                passive_entities[row] = new PassiveEnt(
                    x,
                    (int)( height_8 + random(height-height_8-gnd_dirtBuffer[x]) ),
                    passiveType.SHARK_FISH
                );
                return;
            }
            
            //spawn normal fish
            passive_entities[row] = new PassiveEnt(
                x,
                (int)( height_8 + random(height-height_8-gnd_dirtBuffer[x]) ),
                passiveType.FISH
            );
        break;
        case 1:
            //spawn crab
            passive_entities[row] = new PassiveEnt(
                x,
                (int)( height-gnd_dirtBuffer[x]-crab_offsetY-random(height_8) ),
                passiveType.CRAB
            );
        break;
    }
}



// ----------------- Class -----------------
class PassiveEnt extends Entity{
    
    //attributes
    passiveType type;
    int moveCnt = passive_moveCntMax;
    int nbr = 0;
    Bubble[] air = new Bubble[passive_bubblesNbr];
    Fire[] fireFrag = new Fire[passive_fireFragNbr];
    
    //methods
    PassiveEnt(float x, float y, passiveType p){
        //basic init
        this.x = x;
        this.y = y;
        this.passive = true;
        this.type = p;
        
        //fireFrag init
        for(int f=0; f < passive_fireFragNbr; f++)
            this.fireFrag[f] = new Fire(
                this.x, this.y,
                passive_hitboxX, passive_hitboxY
            );
        
        //special attributes
        switch(p){
            case FIRE_FISH:
            case FISH:
                this.nbr = (int)random(3);
            break;
            case CRAB:
                this.nbr = (int)random(2);
            break;
            default:
        }
        this.speed = (passive_speedMin+passive_speedMin)/2;
        
        //bubbles init
        for(byte b=0; b < passive_bubblesNbr; b++)
            this.air[b] = new Bubble();
    }
    
    
    
    void update(int e){
        //alive or not
        if(!this.alive){
            deletePassiveEntity(e);
            return;
        }
        
        //randomly changing direction
        if(this.moveCnt == 0){
            if(random(1) > 0.5)
                this.vectorX = random(200)-100;
            else{
                if(this.type == passiveType.CRAB)
                    this.vectorY = height-gnd_dirtBuffer[(int)this.x]-this.y-crab_offsetY + random(10)-5;
                else
                    this.vectorY = random(200)-100;
            }
            this.moveCnt = passive_moveCntMax;
        }
        this.moveCnt--;
        
        //maintain speed
        //this.speed += random(2)-5;
        if(this.speed < passive_speedMin)
            this.speed += ent_speedStep;
        if(this.speed > passive_speedMax)
            this.speed -= ent_speedStep;
        
        //movements
        double coef = this.calcMoveCoef();
        this.tryMove(
            (int)(this.x + this.vectorX * coef),
            (int)(this.y + this.vectorY * coef),
            passive_hitboxX, passive_hitboxY
        );
        
        //particles update
        switch(this.type){
            case FIRE_FISH:
                //fire
                for(int f=0; f < passive_fireFragNbr; f++)
                    this.fireFrag[f].update(
                        this.x, this.y,
                        passive_hitboxX, passive_hitboxY
                    );
            case FISH:
                //bubbles
                for(byte b=0; b < passive_bubblesNbr; b++){
                    if(this.air[b].cnt > 0)
                        this.air[b].update();
                    else{
                        if(random(100) > passive_bubbleRate){
                            if(this.right)
                                this.air[b].activate(
                                    this.x+passive_hitboxX + random(4)-2,
                                    this.y                 + random(4)-2
                                );
                            else
                                this.air[b].activate(
                                    this.x-passive_hitboxX + random(4)-2,
                                    this.y                 + random(4)-2
                                );
                            break;
                        }
                    }
                }
            break;
            default:
        }
        
        //entity update
        this.entityUpdate();
    }
    
    
    
    void show(){
        //explosion
        if(this.explosionCnt > 0){
            fill(220,220,0);
            for(byte d=0; d < ent_explosionDivs; d++)
                rect(this.explosionX[d]-gnd_deltaX-2,this.explosionY[d]-2, 2,2);
            return;
        }
        
        switch(this.type){
            case FIRE_FISH:
                //fire
                showFire(this.fireFrag,-gnd_deltaX);
            case FISH:
                //fish
                if(this.right)
                    image(img_fish[this.nbr][1], this.x-gnd_deltaX, this.y);
                else
                    image(img_fish[this.nbr][0], this.x-gnd_deltaX,this.y);
                
                //bubbles
                for(byte b=0; b < passive_bubblesNbr; b++){
                    if(this.air[b].cnt > 0)
                        this.air[b].show(-gnd_deltaX);
                }
            break;
            case SHARK_FISH:
                if(this.right)
                    image(img_sharkFish_right, this.x-gnd_deltaX, this.y);
                else
                    image(img_sharkFish_left, this.x-gnd_deltaX,this.y);
            break;
            case CRAB:
                image(img_crab[this.nbr], this.x-gnd_deltaX,this.y);
            break;
        }
    }
    
    
    
    void setAttributesFrom(PassiveEnt p){
        //basics
        this.x       = p.x;          this.y       = p.y;
        this.vectorX = p.vectorX;    this.vectorY = p.vectorY;
        this.speed   = p.speed;
        this.right   = p.right;
        this.moveCnt = p.moveCnt;
        this.nbr     = p.nbr;
        this.alive   = p.alive;
        this.type    = p.type;
        this.explosionCnt = p.explosionCnt;
        
        //bubbles
        for(int b=0; b < passive_bubblesNbr; b++)
            this.air[b].setAttributesFrom(p.air[b]);
        
        //fire
        for(int f=0; f < passive_fireFragNbr; f++)
            this.fireFrag[f].setAttributesFrom(p.fireFrag[f]);
    }
}
