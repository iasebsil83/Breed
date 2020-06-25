// ---------------- Initialisation ----------------
byte display_screenshotCnt;
float coo_coef = 0.015625;



//---------------- Execution ----------------
void display(){
    switch(menu){
        case START:
            
            //start menu
            image(img_startMenu,0,0);
            
        break;
        case GAME:
            if(display_screenshotCnt > 0){
                
                //taking screenshot
                background(255,255,255);
                display_screenshotCnt--;
            
            }else{
                
                //water
                background(0);
                image(img_background,0,0);
                
                //sea bed
                fill(gnd_color);
                for(int x=0; x < width; x++)
                    rect(x,height,1,-gnd_buffer[gnd_deltaX+x]);
                
                //turtles
                mother.show();
                for(byte c=0; c < CHILDREN_LENGTH; c++)
                    children[c].show();
                
                //sound icon
                if(snd_on)
                    image(img_sound[1],width-40,height-40);
                else
                    image(img_sound[0],width-40,height-40);
                
                //coordinates
                /*
                println(
                    "X:" + (gnd_deltaX+mother.x)*coo_coef +
                    ", Y:" + mother.y*coo_coef
                );
                */
            }
        break;
    }
}
