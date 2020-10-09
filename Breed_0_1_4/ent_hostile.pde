// ---------------- Initialisation ----------------
//hitboxes
final byte hostile_hitboxX = 20;
final byte hostile_hitboxY = 20;
//storage
final int hostile_entitiesCap = 50;
int hostile_entitiesLen = 0;
HostileEnt[] hostile_entities;
//movement
final int hostile_randomMoveCntMax = 5;
//types
enum hostileType{
    CAN,
    PLASTIC_BAG
};



// ---------------- Functions ----------------
void deleteHostileEntity(int e){
    for(int h=e; h < hostile_entitiesLen-1; h++)
        hostile_entities[e].setAttributesFrom(hostile_entities[e+1]);
    hostile_entitiesLen--;
}

void spawnHostile(int x){
    //check for a dead one in the list
    int row = -1;
    for(int e=0; e < hostile_entitiesLen; e++){
        if(!hostile_entities[e].alive){
            row = e;
            break;
        }
    }
    //if not found
    if(row == -1)
        row = hostile_entitiesLen++;
    
    //spawn cap
    if(hostile_entitiesLen >= hostile_entitiesCap-1){
        hostile_entitiesLen--;
        return;
    }
    
    //spawn hostile entity
    switch((int)random(2)){
        case 0:
            //spawn can
            hostile_entities[row] = new HostileEnt(
                x, (int)( height_8 + random(height-height_8-gnd_dirtBuffer[x]) ),
                hostileType.CAN
            );
        break;
        case 1:
            //spawn plastic bag
            hostile_entities[row] = new HostileEnt(
                x, (int)( height_8 + random(height-height_8-gnd_dirtBuffer[x]) ),
                hostileType.PLASTIC_BAG
            );
        break;
    }
}



// ----------------- Class -----------------
class HostileEnt extends Entity{
    
    //attributes
    int nbr = 0;
    int randomMoveCnt = 0;
    hostileType type;
    
    
    
    //methods
    HostileEnt(float x, float y, hostileType h){
        //basic init
        this.x = x;
        this.y = y;
        this.passive = false;
        this.type = h;
        this.nbr = (int)random(2);
    }
    
    
    
    void update(int e){
        //alive or not
        if(!this.alive){
            deleteHostileEntity(e);
            return;
        }
        
        //set speed (security)
        if(this.speed != 0)
            this.speed = 0;
        
        //randomly moving
        if(this.randomMoveCnt <= 0){
            this.x += random(4) - 1.9999;
            this.y += random(4) - 1.9999;
            this.randomMoveCnt = hostile_randomMoveCntMax;
        }
        this.randomMoveCnt--;
        
        //entity update
        this.entityUpdate();
    }
    
    
    
    void show(){
        //explosion
        if(this.explosionCnt > 0){
            fill(100,100,100);
            for(byte d=0; d < ent_explosionDivs; d++)
                rect(this.explosionX[d]-gnd_deltaX-2,this.explosionY[d]-2, 2,2);
            return;
        }
        
        switch(this.type){
            case CAN:
                image(img_can[this.nbr], this.x-gnd_deltaX,this.y);
            break;
            case PLASTIC_BAG:
                image(img_plasticBag[this.nbr], this.x-gnd_deltaX,this.y);
            break;
        }
    }
    
    
    
    void setAttributesFrom(HostileEnt h){
        this.x       = h.x;
        this.y       = h.y;
        this.vectorX = h.vectorX;
        this.vectorY = h.vectorY;
        this.speed   = h.speed;
        this.right   = h.right;
        this.nbr     = h.nbr;
        this.alive   = h.alive;
        this.type    = h.type;
        this.explosionCnt = h.explosionCnt;
    }
}
