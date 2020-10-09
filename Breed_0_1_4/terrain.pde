// ---------------- Initialisation ----------------
//terrain scroll
final int mother_terrain_max = 7*WIDTH/8;
final int mother_terrain_min = WIDTH/8;
final byte mother_scrollStep = 8;
//smooth parameters
final float gnd_diff_max = 1;
final byte gnd_backSmoothingNbr = 4; //the number of values that will be checked for the new value to be set
//lands
int gnd_prevLand = -1;
int gnd_prevAmp = height_8;
float gnd_prevFreq = 0.01;
int gnd_nextLand = +0;
int gnd_nextAmp = height_8;
float gnd_nextFreq = 0.01;
//buffers
final int gnd_bufferLen = 10*WIDTH;
final int gnd_bufferLen_2 = gnd_bufferLen/2;
int gnd_deltaX = gnd_bufferLen_2;
short[] gnd_dirtBuffer;
byte[] gnd_shellBuffer;  //0:nothing, 1:shell0,  2:shell1, 3:shell2, 4:shell3
byte[] gnd_fossilBuffer; //0:nothing, 1:fossil0, 2:fossil1
byte[] gnd_seagrassBuffer;
short[][] gnd_waterColorBuffer; //biome buffers
short[][] gnd_groundColorBuffer;
//biomes
enum biome{
    OCEAN,
    DEEP_OCEAN,
    CORAL_BAY,
    VOLCANO,
    ICY_OCEAN
};
final float gnd_biomes_oceanRate     = 20.0;
final float gnd_biomes_deepOceanRate = 20.0;
final float gnd_biomes_coralBayRate  = 20.0;
final float gnd_biomes_volcanoRate   = 20.0;
final float gnd_biomes_IcyOceanRate  = 20.0;
biome gnd_biomes_leftSideNbr  = biome.OCEAN; //default values
biome gnd_biomes_rightSideNbr = biome.OCEAN;



void initGround(){
    //init buffer
    gnd_dirtBuffer     = new short[gnd_bufferLen];
    gnd_shellBuffer    = new byte [gnd_bufferLen];
    gnd_fossilBuffer   = new byte [gnd_bufferLen];
    gnd_seagrassBuffer = new byte [gnd_bufferLen];
    gnd_waterColorBuffer  = new short[gnd_bufferLen][3];
    gnd_groundColorBuffer = new short[gnd_bufferLen][3];
    
    //check land files
    getHalfBuffer(0);
    getHalfBuffer(gnd_bufferLen_2);
}



// ---------------- Functions ----------------
//useful
String sizeIn4(int i){
    if(i < 0){
        i *= -1;
        if(i > 9999)
            return "-0000";
        else if(i > 999)
            return "-" + i;
        else if(i > 99)
            return "-0" + i;
        else if(i > 9)
            return "-00" + i;
        return "-000" + i;
    }else{
        if(i > 9999)
            return "0000";
        else if(i > 999)
            return "" + i;
        else if(i > 99)
            return "0" + i;
        else if(i > 9)
            return "00" + i;
        return "000" + i;
    }
}

void leftShiftBuffer(){
    for(int x=0; x < gnd_bufferLen_2; x++){
        gnd_dirtBuffer    [x] = gnd_dirtBuffer    [gnd_bufferLen_2+x];
        gnd_shellBuffer   [x] = gnd_shellBuffer   [gnd_bufferLen_2+x];
        gnd_fossilBuffer  [x] = gnd_fossilBuffer  [gnd_bufferLen_2+x];
        gnd_seagrassBuffer[x] = gnd_seagrassBuffer[gnd_bufferLen_2+x];
        gnd_waterColorBuffer[x][0] = gnd_waterColorBuffer[gnd_bufferLen_2+x][0];
        gnd_waterColorBuffer[x][1] = gnd_waterColorBuffer[gnd_bufferLen_2+x][1];
        gnd_waterColorBuffer[x][2] = gnd_waterColorBuffer[gnd_bufferLen_2+x][2];
        gnd_groundColorBuffer[x][0] = gnd_groundColorBuffer[gnd_bufferLen_2+x][0];
        gnd_groundColorBuffer[x][1] = gnd_groundColorBuffer[gnd_bufferLen_2+x][1];
        gnd_groundColorBuffer[x][2] = gnd_groundColorBuffer[gnd_bufferLen_2+x][2];
    }
}

void rightShiftBuffer(){
    for(int x=0; x < gnd_bufferLen_2; x++){
        gnd_dirtBuffer    [gnd_bufferLen_2+x] = gnd_dirtBuffer    [x];
        gnd_shellBuffer   [gnd_bufferLen_2+x] = gnd_shellBuffer   [x];
        gnd_fossilBuffer  [gnd_bufferLen_2+x] = gnd_fossilBuffer  [x];
        gnd_seagrassBuffer[gnd_bufferLen_2+x] = gnd_seagrassBuffer[x];
        gnd_waterColorBuffer[gnd_bufferLen_2+x][0] = gnd_waterColorBuffer[x][0];
        gnd_waterColorBuffer[gnd_bufferLen_2+x][1] = gnd_waterColorBuffer[x][1];
        gnd_waterColorBuffer[gnd_bufferLen_2+x][2] = gnd_waterColorBuffer[x][2];
        gnd_groundColorBuffer[gnd_bufferLen_2+x][0] = gnd_groundColorBuffer[x][0];
        gnd_groundColorBuffer[gnd_bufferLen_2+x][1] = gnd_groundColorBuffer[x][1];
        gnd_groundColorBuffer[gnd_bufferLen_2+x][2] = gnd_groundColorBuffer[x][2];
    }
}

void getHalfBuffer(int startIndex){
    
    //check for the corresponding land file
    String[] text;
    if(startIndex == 0)
        text = loadStrings("lands/" + sizeIn4(gnd_prevLand));
    else
        text = loadStrings("lands/" + sizeIn4(gnd_nextLand));
    
    try{
        if(startIndex == 0){
            //set ground values for prevLand
            gnd_prevAmp = parseInt(text[0]);
            gnd_prevFreq = parseFloat(text[1]);
            
            //set left side of buffer
            String[][] splitedText = new String[10][];
            for(int a=0; a < 10; a++)
                splitedText[a] = text[a+2].split(",");
            for(int x=0; x < gnd_bufferLen_2; x++){
                gnd_dirtBuffer    [x] = (short)parseInt(splitedText[0][x]);
                gnd_shellBuffer   [x] = (byte )parseInt(splitedText[1][x]);
                gnd_fossilBuffer  [x] = (byte )parseInt(splitedText[2][x]);
                gnd_seagrassBuffer[x] = (byte )parseInt(splitedText[3][x]);
                gnd_waterColorBuffer[x][0]  = (short)parseInt(splitedText[4][x]);
                gnd_waterColorBuffer[x][1]  = (short)parseInt(splitedText[5][x]);
                gnd_waterColorBuffer[x][2]  = (short)parseInt(splitedText[6][x]);
                gnd_groundColorBuffer[x][0] = (short)parseInt(splitedText[7][x]);
                gnd_groundColorBuffer[x][1] = (short)parseInt(splitedText[8][x]);
                gnd_groundColorBuffer[x][2] = (short)parseInt(splitedText[9][x]);
            }
        }else{
            //set ground values for nextLand
            gnd_nextAmp = parseInt(text[0]);
            gnd_nextFreq = parseFloat(text[1]);
            
            //set right side of buffer
            String[][] splitedText = new String[10][];
            for(int a=0; a < 10; a++)
                splitedText[a] = text[a+2].split(",");
            for(int x=0; x < gnd_bufferLen_2; x++){
                gnd_dirtBuffer    [gnd_bufferLen_2+x] = (short)parseInt(splitedText[0][x]);
                gnd_shellBuffer   [gnd_bufferLen_2+x] = (byte )parseInt(splitedText[1][x]);
                gnd_fossilBuffer  [gnd_bufferLen_2+x] = (byte )parseInt(splitedText[2][x]);
                gnd_seagrassBuffer[gnd_bufferLen_2+x] = (byte )parseInt(splitedText[3][x]);
                gnd_waterColorBuffer[gnd_bufferLen_2+x][0]  = (short)parseInt(splitedText[4][x]);
                gnd_waterColorBuffer[gnd_bufferLen_2+x][1]  = (short)parseInt(splitedText[5][x]);
                gnd_waterColorBuffer[gnd_bufferLen_2+x][2]  = (short)parseInt(splitedText[6][x]);
                gnd_groundColorBuffer[gnd_bufferLen_2+x][0] = (short)parseInt(splitedText[7][x]);
                gnd_groundColorBuffer[gnd_bufferLen_2+x][1] = (short)parseInt(splitedText[8][x]);
                gnd_groundColorBuffer[gnd_bufferLen_2+x][2] = (short)parseInt(splitedText[9][x]);
            }
        }
    }catch(Exception e){
        //can't find a correct land file
        //gnd_nextAmp = ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< BUG ?
        //gnd_nextFreq = ;
        
        generateHalfBuffer(startIndex);
        if(startIndex == 0)
            saveHalfBuffer(0);
        else
            saveHalfBuffer(gnd_bufferLen_2);
    }
}

void saveHalfBuffer(int startIndex){
    String[] text = new String[12];
    if(startIndex == 0){
        //set prevLand values
        text[0] = str(gnd_prevAmp);
        text[1] = str(gnd_prevFreq);
        
        //set left side of buffer
        for(byte a=2; a < 12; a++)
            text[a] = "";
        for(int x=0; x < gnd_bufferLen_2; x++){
            text[2] += gnd_dirtBuffer    [x] + ",";
            text[3] += gnd_shellBuffer   [x] + ",";
            text[4] += gnd_fossilBuffer  [x] + ",";
            text[5] += gnd_seagrassBuffer[x] + ",";
            text[ 6] += gnd_waterColorBuffer [x][0] + ",";
            text[ 7] += gnd_waterColorBuffer [x][1] + ",";
            text[ 8] += gnd_waterColorBuffer [x][2] + ",";
            text[ 9] += gnd_groundColorBuffer[x][0] + ",";
            text[10] += gnd_groundColorBuffer[x][1] + ",";
            text[11] += gnd_groundColorBuffer[x][2] + ",";
        }
        
        //save prevLand
        saveStrings("lands/" + sizeIn4(gnd_prevLand),text);
    }else{
        //set nextLand values
        text[0] = str(gnd_nextAmp);
        text[1] = str(gnd_nextFreq);
        
        //set right side of buffer
        for(byte a=2; a < 12; a++)
            text[a] = "";
        for(int x=0; x < gnd_bufferLen_2; x++){
            text[2] += gnd_dirtBuffer    [gnd_bufferLen_2+x] + ",";
            text[3] += gnd_shellBuffer   [gnd_bufferLen_2+x] + ",";
            text[4] += gnd_fossilBuffer  [gnd_bufferLen_2+x] + ",";
            text[5] += gnd_seagrassBuffer[gnd_bufferLen_2+x] + ",";
            text[ 6] += gnd_waterColorBuffer [gnd_bufferLen_2+x][0] + ",";
            text[ 7] += gnd_waterColorBuffer [gnd_bufferLen_2+x][1] + ",";
            text[ 8] += gnd_waterColorBuffer [gnd_bufferLen_2+x][2] + ",";
            text[ 9] += gnd_groundColorBuffer[gnd_bufferLen_2+x][0] + ",";
            text[10] += gnd_groundColorBuffer[gnd_bufferLen_2+x][1] + ",";
            text[11] += gnd_groundColorBuffer[gnd_bufferLen_2+x][2] + ",";
        }
        
        //save nextLand
        saveStrings("lands/" + sizeIn4(gnd_nextLand),text);
    }
}

void generateHalfBuffer(int startIndex){
    //set ground height limits
    int maxGroundHeight;
    int middleGroundHeight;
    int minGroundHeight;
    switch(gnd_biomes_leftSideNbr){
        case DEEP_OCEAN:
            minGroundHeight = height_12;
            middleGroundHeight = height_12;
            maxGroundHeight = height_8;
        break;
        case CORAL_BAY:
            minGroundHeight = height_24;
            middleGroundHeight = height_8;
            maxGroundHeight = height_12;
        break;
        case VOLCANO:
            minGroundHeight = height_24;
            middleGroundHeight = height_8;
            maxGroundHeight = height_12;
        break;
        case ICY_OCEAN:
            minGroundHeight = height_24;
            middleGroundHeight = height_8;
            maxGroundHeight = height_4;
        break;
        case OCEAN:
        default:
            minGroundHeight = height_12;
            middleGroundHeight = height_4;
            maxGroundHeight = height_8;
        break;
    }
    
    //terrain generation
    if(startIndex == 0){
        //generating from right to left
        for(int x=gnd_bufferLen_2-1; x >= 0; x--){
            
            //set new ground values (amp, freq)
            if(random(1) > 0.5)
                gnd_prevAmp++;
            else
                gnd_prevAmp--;
            gnd_prevAmp += 2*random(1001)/1000;
            if(gnd_prevAmp < minGroundHeight)
                gnd_prevAmp += 2;
            if(gnd_prevAmp > maxGroundHeight)
                gnd_prevAmp -= 2;
            if(random(1) > 0.5)
                gnd_prevFreq += 0.00006;
            else
                gnd_prevFreq -= 0.00006;
            
            //set dirt buffer
            gnd_dirtBuffer[x] = (short)( middleGroundHeight + gnd_prevAmp*cos(gnd_prevFreq*x) );
            
            //set other stuff (shells, fossils, seagrass, sea and ground color)
            setMiscellaneous(gnd_biomes_leftSideNbr,x);
        }
    }else{
        //generating from left to right
        for(int x=startIndex; x < startIndex+gnd_bufferLen_2; x++){
            
            //set new ground values (amp, freq)
            if(random(1) < 0.5)
                gnd_nextAmp++;
            else
                gnd_nextAmp--;
            gnd_nextAmp += 2*random(1001)/1000;
            if(gnd_nextAmp < minGroundHeight)
                gnd_nextAmp += 2;
            if(gnd_nextAmp > maxGroundHeight)
                gnd_nextAmp -= 2;
            if(random(1) < 0.5)
                gnd_nextFreq += 0.00006;
            else
                gnd_nextFreq -= 0.00006;
            
            //set dirt buffer
            gnd_dirtBuffer[x] = (short)( height_4 + gnd_nextAmp*cos(gnd_nextFreq*x) );
            
            //set other stuff (shells, fossils, seagrass, sea and ground color)
            setMiscellaneous(gnd_biomes_rightSideNbr,x);
        }
    }
    
    //smoothing a bit dirt and color buffers
    for(int x=startIndex+gnd_backSmoothingNbr; x < startIndex+gnd_bufferLen_2; x++){
        for(int n=1; n < gnd_backSmoothingNbr; n++){
            if( abs(gnd_dirtBuffer[x-n]-gnd_dirtBuffer[x]) > gnd_diff_max )
                gnd_dirtBuffer[x] = (short)( (2*gnd_dirtBuffer[x-n] + gnd_dirtBuffer[x])/3 );
        }
    }
}

void terrainScroll(){
    //going right
    if(mother.x > mother_terrain_max){
        gnd_deltaX += mother_scrollStep;
        
        //fire boost
        if(mother.fireCnt > 0)
            gnd_deltaX += 2*mother_scrollStep;
        
        //going too far to right for gnd_buffer
        if(gnd_deltaX+width > gnd_bufferLen){
            saveHalfBuffer(0);
            gnd_prevLand++;
            gnd_nextLand++;
            gnd_deltaX -= gnd_bufferLen_2;
            leftShiftBuffer();
            getHalfBuffer(gnd_bufferLen_2);
        }
        
    //going left
    }else if(mother.x < mother_terrain_min){
        gnd_deltaX -= mother_scrollStep;
        
        //fire boost
        if(mother.fireCnt > 0)
            gnd_deltaX -= 2*mother_scrollStep;
        
        //going too far to left for gnd_buffer
        if(gnd_deltaX < 0){
            saveHalfBuffer(gnd_bufferLen_2);
            gnd_prevLand--;
            gnd_nextLand--;
            gnd_deltaX += gnd_bufferLen_2;
            rightShiftBuffer();
            getHalfBuffer(0);
        }
        
    }
}

//generation details for each biome
void setMiscellaneous(biome b, int x){
    switch(b){
        case DEEP_OCEAN:
            //set shell buffer
            if(random(30) > 29.9)
                gnd_shellBuffer[x] = (byte)(random(4)+1);
            else
                gnd_shellBuffer[x] = 0;
           
            //set fossil buffer
            if(random(100) > 99.9)
                gnd_fossilBuffer[x] = (byte)(random(3)+1);
            else
                gnd_fossilBuffer[x] = 0;
            
            //set seagrass buffer
            if(x%33 == 0)
                gnd_seagrassBuffer[x] = (byte)random(20);
            
            //set water color
            gnd_waterColorBuffer[x][0] = 20;
            gnd_waterColorBuffer[x][1] = 30;
            gnd_waterColorBuffer[x][2] = 255;
            
            //set ground color
            gnd_groundColorBuffer[x][0] = 110;
            gnd_groundColorBuffer[x][1] = 80;
            gnd_groundColorBuffer[x][2] = 20;
        break;
        case CORAL_BAY:
            //set shell buffer
            if(random(50) > 49.9)
                gnd_shellBuffer[x] = (byte)(random(4)+1);
            else
                gnd_shellBuffer[x] = 0;
           
            //set fossil buffer
            if(random(50) > 49.9)
                gnd_fossilBuffer[x] = (byte)(random(3)+1);
            else
                gnd_fossilBuffer[x] = 0;
            
            //set seagrass buffer
            if(x%9 == 0)
                gnd_seagrassBuffer[x] = (byte)random(10);
            
            //set water color
            gnd_waterColorBuffer[x][0] = 20;
            gnd_waterColorBuffer[x][1] = 30;
            gnd_waterColorBuffer[x][2] = 255;
            
            //set ground color
            gnd_groundColorBuffer[x][0] = 110;
            gnd_groundColorBuffer[x][1] = 80;
            gnd_groundColorBuffer[x][2] = 20;
        break;
        case VOLCANO:
            //set shell buffer
            if(random(80) > 79.9)
                gnd_shellBuffer[x] = (byte)(random(4)+1);
            else
                gnd_shellBuffer[x] = 0;
           
            //set fossil buffer
            if(random(30) > 29.9)
                gnd_fossilBuffer[x] = (byte)(random(3)+1);
            else
                gnd_fossilBuffer[x] = 0;
            
            //set water color
            gnd_waterColorBuffer[x][0] = 20;
            gnd_waterColorBuffer[x][1] = 30;
            gnd_waterColorBuffer[x][2] = 255;
            
            //set ground color
            gnd_groundColorBuffer[x][0] = 110;
            gnd_groundColorBuffer[x][1] = 80;
            gnd_groundColorBuffer[x][2] = 20;
        break;
        case ICY_OCEAN:
            //set shell buffer
            gnd_shellBuffer[x] = 0;
           
            //set fossil buffer
            gnd_fossilBuffer[x] = 0;
            
            //set water color
            gnd_waterColorBuffer[x][0] = 20;
            gnd_waterColorBuffer[x][1] = 30;
            gnd_waterColorBuffer[x][2] = 255;
            
            //set ground color
            gnd_groundColorBuffer[x][0] = 110;
            gnd_groundColorBuffer[x][1] = 80;
            gnd_groundColorBuffer[x][2] = 20;
        break;
        case OCEAN:
        default:
            //set shell buffer
            if(random(40) > 39.9)
                gnd_shellBuffer[x] = (byte)(random(4)+1);
            else
                gnd_shellBuffer[x] = 0;
           
            //set fossil buffer
            if(random(80) > 79.9)
                gnd_fossilBuffer[x] = (byte)(random(3)+1);
            else
                gnd_fossilBuffer[x] = 0;
            
            //set seagrass buffer
            if(x%11 == 0)
                gnd_seagrassBuffer[x] = (byte)random(100);
            else
                gnd_seagrassBuffer[x] = 1;
            
            //set water color
            gnd_waterColorBuffer[x][0] = 20;
            gnd_waterColorBuffer[x][1] = 30;
            gnd_waterColorBuffer[x][2] = 255;
            
            //set ground color
            gnd_groundColorBuffer[x][0] = 110;
            gnd_groundColorBuffer[x][1] = 80;
            gnd_groundColorBuffer[x][2] = 20;
        break;
    }
}
