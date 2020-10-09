// ---------------- Initialisation ----------------
//text
PFont display_textFont;
final int display_textSize = 30;
//scores
final int display_scoreX = 10;
//coordinates
final float coo_coef = 0.015625;
//smooth parameter
final int sea_diffMax = 1;
//screenshot
byte display_screenshotCnt;
//gauges
float display_randDeltaX_gauge = 0;
float display_randDeltaX = 0;
float display_randFreq_gauge = 0;
float display_randFreq = 0.06;
//counter
final int display_cntMax = 1000;
int display_cnt = 0;
byte display_sens = 1;
//seagrass
final float seagrass_diffMax = 0.5;
final float seagrass_freqStep = 0.0019;
final float seagrass_ampStep  = 0.1;
float[][] seagrass_randFreq;
float[][] seagrass_randAmp;



//---------------- Functions -----------------
float wave(float x){
    while(x < 0)
        x += PImul2;
    float c = (x+PI/4)/PI;
    c = c - parseInt(c);
    if(c > 0.3 && c < 0.8)
        return 1-abs(sin(x));
    return abs(cos(x));
}

void initDisplay(){
    //text init
    textAlign(LEFT);
    display_textFont = createFont(
        "Monospaced.bolditalic",
        display_textSize,
        true
    );
    textFont(display_textFont);
}

void initSeagrass(){
    seagrass_randFreq = new float[width][127];
    seagrass_randAmp  = new float[width][127];
    for(int x=0; x < width; x++){
        for(byte y=0; y < 127; y++){
            seagrass_randFreq[x][y] = 1;
            seagrass_randAmp [x][y] = 1;
        }
    }
}

void drawSea(){
    
    //set waves shift gauge
    if(random(1) > 0.5)
        display_randDeltaX_gauge -= 0.001*random(20);
    if(random(1) > 0.5)
        display_randDeltaX_gauge += 0.001*random(20);
    if(display_randDeltaX_gauge < -0.1)
        display_randDeltaX_gauge = -0.1;
    if(display_randDeltaX_gauge > 0.1)
        display_randDeltaX_gauge = 0.1;
    
    //set waves frequency gauge
    if(random(1) > 0.5)
        display_randFreq_gauge -= 0.000001;//*random(20);
    if(random(1) > 0.5)
        display_randFreq_gauge += 0.000001;//*random(20);
    if(display_randFreq_gauge < -0.00001)
        display_randFreq_gauge = -0.00001;
    if(display_randFreq_gauge > 0.00001)
        display_randFreq_gauge = 0.00001;
    
    //set waves shift & frequence
    display_randDeltaX += display_randDeltaX_gauge;
    display_randFreq += display_randFreq_gauge;
    
    //generate random waves
    int[] y = new int[width];
    for(int x=0; x < width; x++)
        y[x] = (int)( -h_height_12 - height_48*wave(display_randDeltaX/2 + display_randFreq*x/4) );
    
    //smoothing a bit
    for(int x=1; x < width; x++){
        if(abs(y[x]-y[x-1]) > sea_diffMax)
            y[x] = (5*y[x-1] + y[x])/6;
        rect(x,height, 1,y[x]);
    }
}

void drawSeagrass(int x, int h){
    if(h == 0)
        return;
    fill(0,190,0);
    float[] fx = new float[h]; //use a floatX[] for better precision
    for(int y=0; y < h; y++){
        //start calculation from previous value
        if(y == 0)
            fx[0] = x;
        else
            fx[y] = fx[y-1];
        
        //set randomAmp
        if(random(1) > 0.5)
            seagrass_randAmp[x][y] += seagrass_ampStep;
        if(random(1) > 0.5)
            seagrass_randAmp[x][y] -= seagrass_ampStep;
        
        //set randomFreq
        if(random(1) > 0.5)
            seagrass_randFreq[x][y] += seagrass_freqStep;
        if(random(1) > 0.5)
            seagrass_randFreq[x][y] -= seagrass_freqStep;
        
        //set new floatX[x]
        fx[y] += seagrass_randAmp[x][y]*cos( (10*y+display_cnt)*0.019*seagrass_randFreq[x][y] );
    }
    
    //smoothing a bit
    for(int y=1; y < h; y++){
        if(abs(fx[y]-fx[y-1]) > seagrass_diffMax)
            fx[y] = (2*fx[y-1] + fx[y])/3;
        rect(
            fx[y]-2,
            height-gnd_dirtBuffer[gnd_deltaX+x]-y,
        4,4);
    }
}



//---------------- Execution ----------------
void display(){
    //display counter
    display_cnt += display_sens*(1/*+random(2)*/);
    if(display_cnt > display_cntMax)
        display_sens = -1;
    if(display_cnt < 0)
        display_sens = 1;
    
    //display
    switch(menu){
        case START:
            //start menu
            image(img_startMenu,0,0);
        break;
        case END:
        case GAME:
            if(display_screenshotCnt > 0){
                
                //taking screenshot
                background(255,255,255);
                display_screenshotCnt--;
            }else{
                
                //background
                image(img_sky,0,0);
                
                //sea
                fill(0,0,255);
                drawSea();
                
                //passive entities
                for(int e=0; e < passive_entitiesLen; e++)
                    passive_entities[e].show();
                
                //hostile entities
                for(int e=0; e < hostile_entitiesLen; e++)
                    hostile_entities[e].show();
                
                //turtles
                if(mother.alive)
                    mother.show();
                for(byte c=0; c < childrenLen; c++){
                    if(children[c].alive)
                        children[c].show();
                }
                
                //sea bed
                for(int x=0; x < width; x++){
                    //ground
                    fill(
                        gnd_groundColorBuffer[x][0],
                        gnd_groundColorBuffer[x][1],
                        gnd_groundColorBuffer[x][2]
                    );
                    rect(x,height,1,-gnd_dirtBuffer[gnd_deltaX+x]);
                }
                
                for(int x=0; x < width; x++){
                    //fossils
                    if(gnd_fossilBuffer[gnd_deltaX+x] != 0)
                        image(
                            img_fossil[ gnd_fossilBuffer[gnd_deltaX+x]-1 ],
                            x,height-gnd_dirtBuffer[gnd_deltaX+x]/2
                        );
                    
                    //shells
                    if(gnd_shellBuffer[gnd_deltaX+x] != 0)
                        image(
                            img_shell[ gnd_shellBuffer[gnd_deltaX+x]-1 ],
                            x,height-gnd_dirtBuffer[gnd_deltaX+x]
                        );
                    drawSeagrass(x,gnd_seagrassBuffer[gnd_deltaX+x]);
                }
                
                //coordinates
                /*
                println(
                    "X:" + (gnd_deltaX+mother.x)*coo_coef +
                    ", Y:" + mother.y*coo_coef
                );
                */
                fill(255,255,0);
                if(menu == menu_names.END){
                    image(img_endMenu,0,0);
                    text("Score : "      +     score, display_scoreX, height_24   );
                    text("Best Score : " + bestScore, display_scoreX, height_24 + display_textSize+4);
                }else
                    text("Score : " + score, display_scoreX, height_24);
            }
        break;
    }
    //sound icon
    if(snd_on)
        image(img_sound[1],width-40,height-40);
    else
        image(img_sound[0],width-40,height-40);
}
