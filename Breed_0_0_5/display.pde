// ---------------- Initialisation ----------------
final float coo_coef = 0.015625;
final int display_seaDiffMax = 1;
byte display_screenshotCnt;
float display_randDeltaX_gauge = 0;
float display_randDeltaX = 0;
float display_randFreq_gauge = 0;
float display_randFreq = 0.06;



//---------------- Function -----------------
float wave(float x){
    while(x < 0)
        x += PImul2;
    float c = (x+PI/4)/PI;
    c = c - parseInt(c);
    if(c > 0.3 && c < 0.8)
        return 1-abs(sin(x));
    return abs(cos(x));
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
    for(int x=0; x < width; x++){
        y[x] = (int)( -h_height_12 - height_48*wave(display_randDeltaX/2 + display_randFreq*x/4) );
    }
    
    //smoothing a bit
    for(int x=1; x < width; x++){
        if(abs(y[x]-y[x-1]) > display_seaDiffMax)
            y[x] = (5*y[x-1] + y[x])/6;
        rect(
            x, height,
            1, y[x]
        );
    }
}



//---------------- Execution ----------------
void display(){
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
                fill(20,30,225);
                drawSea();
                
                //sea bed
                fill(110,80,20);
                for(int x=0; x < width; x++)
                    //ground
                    rect(x,height,1,-gnd_buffer[gnd_deltaX+x]);
                
                for(int x=0; x < width; x++){
                    //fossils
                    if(gnd_fossilBuffer[gnd_deltaX+x] != 0)
                        image(
                            img_fossil[ gnd_fossilBuffer[gnd_deltaX+x]-1 ],
                            x,height-gnd_buffer[gnd_deltaX+x]/2
                        );
                    
                    //shells
                    if(gnd_shellBuffer[gnd_deltaX+x] != 0)
                        image(
                            img_shell[ gnd_shellBuffer[gnd_deltaX+x]-1 ],
                            x,height-gnd_buffer[gnd_deltaX+x]
                        );
                }
                
                //turtles
                mother.show();
                for(byte c=0; c < CHILDREN_LENGTH; c++){
                    if(children[c].alive)
                        children[c].show();
                }
                
                //coordinates
                /*
                println(
                    "X:" + (gnd_deltaX+mother.x)*coo_coef +
                    ", Y:" + mother.y*coo_coef
                );
                */
                if(menu == menu_names.END)
                    image(img_endMenu,0,0);
            }
        break;
    }
    //sound icon
    if(snd_on)
        image(img_sound[1],width-40,height-40);
    else
        image(img_sound[0],width-40,height-40);
}
