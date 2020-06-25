// ---------------- Initialisation ----------------
final float gnd_diff_max = 1;
final int gnd_buffer_len = 10*WIDTH;
final int gnd_buffer_len_2 = gnd_buffer_len/2;
short[] gnd_buffer;
int gnd_deltaX = gnd_buffer_len_2;
int gnd_prevLand = -1;
int gnd_prevAmp = height_8;
float gnd_prevFreq = 0.01;
int gnd_nextLand = +0;
int gnd_nextAmp = height_8;
float gnd_nextFreq = 0.01;
byte[] gnd_shellBuffer;  //0:nothing, 1:shell0,  2:shell1, 3:shell2, 4:shell3
byte[] gnd_fossilBuffer; //0:nothing, 1:fossil0, 2:fossil1



// ---------------- Functions ----------------
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

void initGround(){
    
    //init buffer
    gnd_buffer       = new short[gnd_buffer_len];
    gnd_shellBuffer  = new byte [gnd_buffer_len];
    gnd_fossilBuffer = new byte [gnd_buffer_len];
    
    //check land files
    getHalfBuffer(0);
    getHalfBuffer(gnd_buffer_len_2);
}

void leftShiftBuffer(){
    for(int x=0; x < gnd_buffer_len_2; x++){
        gnd_buffer      [x] = gnd_buffer      [gnd_buffer_len_2+x];
        gnd_shellBuffer [x] = gnd_shellBuffer [gnd_buffer_len_2+x];
        gnd_fossilBuffer[x] = gnd_fossilBuffer[gnd_buffer_len_2+x];
    }
}

void rightShiftBuffer(){
    for(int x=0; x < gnd_buffer_len_2; x++){
        gnd_buffer      [gnd_buffer_len_2+x] = gnd_buffer      [x];
        gnd_shellBuffer [gnd_buffer_len_2+x] = gnd_shellBuffer [x];
        gnd_fossilBuffer[gnd_buffer_len_2+x] = gnd_fossilBuffer[x];
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
            String[] splitedText2 = text[2].split(",");
            String[] splitedText3 = text[3].split(",");
            String[] splitedText4 = text[4].split(",");
            for(int x=0; x < gnd_buffer_len_2; x++){
                gnd_buffer      [x] = (short)parseInt(splitedText2[x]);
                gnd_shellBuffer [x] = (byte )parseInt(splitedText3[x]);
                gnd_fossilBuffer[x] = (byte )parseInt(splitedText4[x]);
            }
        }else{
            
            //set ground values for nextLand
            gnd_nextAmp = parseInt(text[0]);
            gnd_nextFreq = parseFloat(text[1]);
            
            //set right side of buffer
            String[] splitedText2 = text[2].split(",");
            String[] splitedText3 = text[3].split(",");
            String[] splitedText4 = text[4].split(",");
            for(int x=0; x < gnd_buffer_len_2; x++){
                gnd_buffer      [gnd_buffer_len_2+x] = (short)parseInt(splitedText2[x]);
                gnd_shellBuffer [gnd_buffer_len_2+x] = (byte )parseInt(splitedText3[x]);
                gnd_fossilBuffer[gnd_buffer_len_2+x] = (byte )parseInt(splitedText4[x]);
            }
        }
    }catch(Exception e){
        
        //can't find a correct land file
        generateHalfBuffer(startIndex);
        if(startIndex == 0)
            saveHalfBuffer(0);
        else
            saveHalfBuffer(gnd_buffer_len_2);
    }
}

void saveHalfBuffer(int startIndex){
    String[] text = new String[5];
    if(startIndex == 0){
        
        //set prevLand values
        text[0] = str(gnd_prevAmp);
        text[1] = str(gnd_prevFreq);
        
        //set left side of buffer
        text[2] = "";
        text[3] = "";
        text[4] = "";
        for(int x=0; x < gnd_buffer_len_2; x++){
            text[2] += gnd_buffer      [x] + ",";
            text[3] += gnd_shellBuffer [x] + ",";
            text[4] += gnd_fossilBuffer[x] + ",";
        }
        
        //save prevLand
        saveStrings("lands/" + sizeIn4(gnd_prevLand),text);
    }else{
        
        //set nextLand values
        text[0] = str(gnd_nextAmp);
        text[1] = str(gnd_nextFreq);
        
        //set right side of buffer
        text[2] = "";
        text[3] = "";
        text[4] = "";
        for(int x=0; x < gnd_buffer_len_2; x++){
            text[2] += gnd_buffer      [gnd_buffer_len_2+x] + ",";
            text[3] += gnd_shellBuffer [gnd_buffer_len_2+x] + ",";
            text[4] += gnd_fossilBuffer[gnd_buffer_len_2+x] + ",";
        }
        
        //save nextLand
        saveStrings("lands/" + sizeIn4(gnd_nextLand),text);
    }
}

void generateHalfBuffer(int startIndex){
    if(startIndex == 0){
        
        //generating from right to left
        for(int x=gnd_buffer_len_2-1; x >= 0; x--){
            
            //set new values (amp, freq)
            if(random(1) > 0.5)
                gnd_prevAmp++;
            else
                gnd_prevAmp--;
            gnd_prevAmp += 2*random(1001)/1000;
            if(gnd_prevAmp < height_12)
                gnd_prevAmp += 2;
            if(gnd_prevAmp > height_8)
                gnd_prevAmp -= 2;
            if(random(1) > 0.5)
                gnd_prevFreq += 0.00006;
            else
                gnd_prevFreq -= 0.00006;
            
            //set buffers value
            gnd_buffer[x] = (short)( height_4 + gnd_prevAmp*cos(gnd_prevFreq*x) );
            if(random(50) > 49.9)
                gnd_shellBuffer[x] = (byte)(random(4)+1);
            else
                gnd_shellBuffer[x] = 0;
            if(random(50) > 49.9)
                gnd_fossilBuffer[x] = (byte)(random(2)+1);
            else
                gnd_fossilBuffer[x] = 0;
        }
        
    }else{
        
        //generating from left to right
        for(int x=startIndex; x < startIndex+gnd_buffer_len_2; x++){
            
            //set new values (amp, freq)
            if(random(1) < 0.5)
                gnd_nextAmp++;
            else
                gnd_nextAmp--;
            gnd_nextAmp += 2*random(1001)/1000;
            if(gnd_nextAmp < height_12)
                gnd_nextAmp += 2;
            if(gnd_nextAmp > height_8)
                gnd_nextAmp -= 2;
            if(random(1) < 0.5)
                gnd_nextFreq += 0.00006;
            else
                gnd_nextFreq -= 0.00006;
            
            //set buffers value
            gnd_buffer[x] = (short)( height_4 + gnd_nextAmp*cos(gnd_nextFreq*x) );
            if(random(50) > 49.9)
                gnd_shellBuffer[x] = (byte)(random(4)+1);
            else
                gnd_shellBuffer[x] = 0;
            if(random(50) > 49.9)
                gnd_fossilBuffer[x] = (byte)(random(2)+1);
            else
                gnd_fossilBuffer[x] = 0;
        }
    }
    
    //smoothing a bit
    for(int x=startIndex+4; x < startIndex+gnd_buffer_len_2; x++){
        for(int n=1; n < 4; n++){
            if( abs(gnd_buffer[x-n]-gnd_buffer[x]) > gnd_diff_max )
                gnd_buffer[x] = (short)( (2*gnd_buffer[x-n] + gnd_buffer[x])/3 );
        }
    }
}

void motherTerrainScroll(){
    //going right
    if(mother.x > mother_terrain_max){
        gnd_deltaX += 16;
        
        //going too far to right for gnd_buffer
        if(gnd_deltaX+width > gnd_buffer_len){
            saveHalfBuffer(0);
            gnd_prevLand++;
            gnd_nextLand++;
            gnd_deltaX -= gnd_buffer_len_2;
            leftShiftBuffer();
            getHalfBuffer(gnd_buffer_len_2);
        }
        
    //going left
    }else if(mother.x < mother_terrain_min){
        gnd_deltaX -= 16;
        
        //going too far to left for gnd_buffer
        if(gnd_deltaX < 0){
            saveHalfBuffer(gnd_buffer_len_2);
            gnd_prevLand--;
            gnd_nextLand--;
            gnd_deltaX += gnd_buffer_len_2;
            rightShiftBuffer();
            getHalfBuffer(0);
        }
        
    }
}