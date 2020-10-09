// ---------------- Initialisation ----------------
//speed
final double ent_speedStep = 0.15;
//explosion
final int ent_explosionCntMax = 35;
final byte ent_explosionDivs = 40;
final float ent_explosionStep = 0.1;
//spawn rates
final float passiveHostile_spawnRate = 50;
final float turtle_spawnRate = 99.8;
final float firefish_spawnRate = 80;
final float sharkfish_spawnRate = 90;



// ---------------- Functions ----------------
void initEntities(){
    passive_entities = new PassiveEnt[passive_entitiesCap];
    hostile_entities = new HostileEnt[hostile_entitiesCap];
}

void spawnEntity(){
    //spawning randomly in the whole buffer except screen zone
    int x = (int)random(gnd_bufferLen);
    while(x > gnd_deltaX && x < gnd_deltaX+width)
        x = (int)random(gnd_bufferLen);
    
    //spawn a child turtle
    if(random(100) > turtle_spawnRate){
        if(spawnChildTurtle())
            return;
    }
    
    if(random(100) > passiveHostile_spawnRate)
        spawnPassive(x);
    else
        spawnHostile(x);
}




// ----------------- Class -----------------
class Entity{
    
    //attributes
    float x,y;
    double vectorX = 0;
    double vectorY = 0;
    double speed = 0;
    boolean right = true;
    int explosionCnt = 0; //explosion
    float[] explosionX = new float[ent_explosionDivs];
    float[] explosionY = new float[ent_explosionDivs];
    boolean passive;
    boolean alive = true;
    
    //methods
    double calcMoveCoef(){
        //set movement coef
        double coef = this.speed*0.001/2;
        if(coef > 0.3)
            coef = 0.3;
        this.speed -= ent_speedStep;
        
        //correction of speed value
        if(this.speed < 0)
            this.speed = 0;
        
        return coef;
    }
    
    void tryMove(int newX, int newY, byte hitboxX, byte hitboxY){
        //set hitbox interval
        int minX = newX-hitboxX;
        int maxX = newX+hitboxX;
        int minY = newY-hitboxY;
        int maxY = newY+hitboxY;
        if(minX < 0)
            minX = 0;
        if(maxX > width)
            maxX = width;
        if(minY < height_8) //sea surface limit
            newY = height_8;
        
        //check on whole hitboxX interval
        for(int x=minX; x < maxX; x++){
            if(maxY > height-gnd_dirtBuffer[gnd_deltaX+x]) //ground limits
                newY = height-gnd_dirtBuffer[gnd_deltaX+x]-hitboxY-1;
        }
        this.x = (5*x + newX)/6;
        this.y = (5*y + newY)/6;
    }
    
    void entityUpdate(){
        //set right attribute
        if(this.speed != 0){
            if(this.vectorX > 0)
                this.right = true;
            else
                this.right = false;
        }
        
        //explosion
        if(this.explosionCnt > 0){
            this.explosionCnt--;
            float divAngle = 2*PI/ent_explosionDivs;
            for(byte d=0; d < ent_explosionDivs; d++){
                this.explosionX[d] += (random(100)-30)*ent_explosionStep*cos(d*divAngle);
                this.explosionY[d] += (random(100)-30)*ent_explosionStep*sin(d*divAngle);
            }
            if(this.explosionCnt <= 1)
                this.alive = false;
        }
    }
    
    void explode(){
        if(this.explosionCnt <= 0){
            this.explosionCnt = ent_explosionCntMax;
            for(byte d=0; d < ent_explosionDivs; d++){
                this.explosionX[d] = this.x;
                this.explosionY[d] = this.y;
            }
        }
    }
}
