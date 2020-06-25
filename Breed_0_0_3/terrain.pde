// ---------------- Initialisation ----------------
final float gnd_diff_max = 1;
final int gnd_buffer_len = 10*WIDTH;
final int gnd_buffer_len_2 = gnd_buffer_len/2;
final color gnd_color = color(230,210,200);
short[] gnd_buffer;
int gnd_deltaX = gnd_buffer_len_2;
int gnd_prevLand = -1;
int gnd_prevAmp = height_8;
float gnd_prevFreq = 0.01;
int gnd_nextLand = +0;
int gnd_nextAmp = height_8;
float gnd_nextFreq = 0.01;



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
    gnd_buffer = new short[gnd_buffer_len];
    
    //check land files
    println("trying to get first land file...");
    getHalfBuffer(0);
    println("...done");
    println("trying to get second land file...");
    getHalfBuffer(gnd_buffer_len_2);
    println("...done");
}

void leftShiftBuffer(){
    for(int x=0; x < gnd_buffer_len_2; x++)
        gnd_buffer[x] = gnd_buffer[gnd_buffer_len_2+x];
}

void rightShiftBuffer(){
    for(int x=0; x < gnd_buffer_len_2; x++)
        gnd_buffer[gnd_buffer_len_2+x] = gnd_buffer[x];
}

void getHalfBuffer(int startIndex){
    
    //check for the corresponding land file
    println("    getting land file data...");
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
            String[] splitedText = text[2].split(",");
            for(int x=0; x < gnd_buffer_len_2; x++)
                gnd_buffer[x] = (short)parseInt(splitedText[x]);
        }else{
            
            //set ground values for nextLand
            gnd_nextAmp = parseInt(text[0]);
            gnd_nextFreq = parseFloat(text[1]);
            
            //set right side of buffer
            String[] splitedText = text[2].split(",");
            for(int x=0; x < gnd_buffer_len_2; x++)
                gnd_buffer[gnd_buffer_len_2+x] = (short)parseInt(splitedText[x]);
        }
        println("    ...land file data found and loaded");
    }catch(Exception e){
        
        //can't find a correct land file
        println("    ...cannot find land file data");
        println("    generating and saving half buffer...");
        generateHalfBuffer(startIndex);
        if(startIndex == 0)
            saveHalfBuffer(0);
        else
            saveHalfBuffer(gnd_buffer_len_2);
        println("    ...half buffer generated and saved");
    }
}

void saveHalfBuffer(int startIndex){
    String[] text = new String[3];
    if(startIndex == 0){
        
        //set prevLand values
        text[0] = str(gnd_prevAmp);
        text[1] = str(gnd_prevFreq);
        
        //set left side of buffer
        text[2] = "";
        for(int x=0; x < gnd_buffer_len_2; x++)
            text[2] += gnd_buffer[x] + ",";
        
        //save prevLand
        saveStrings("lands/" + sizeIn4(gnd_prevLand),text);
    }else{
        
        //set nextLand values
        text[0] = str(gnd_nextAmp);
        text[1] = str(gnd_nextFreq);
        
        //set right side of buffer
        text[2] = "";
        for(int x=0; x < gnd_buffer_len_2; x++)
            text[2] += gnd_buffer[gnd_buffer_len_2+x] + ",";
        
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
            
            //set buffer value
            gnd_buffer[x] = (short)( height_4 + gnd_prevAmp*cos(gnd_prevFreq*x) );
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
            
            //set buffer value
            gnd_buffer[x] = (short)( height_4 + gnd_nextAmp*cos(gnd_nextFreq*x) );
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
