// ---------------- Initialisation ----------------
byte display_screenshotCnt;



// ---------------- Functions ----------------



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
                fill(ground_color);
                for(int x=0; x < width; x++)
                    rect(x,height,1,-ground_height[x]);
                
                //turtles
                mother.show();
                for(byte c=0; c < CHILDREN_LENGTH; c++)
                    children[c].show();
                
                //sound icon
                if(snd_on)
                    image(img_sound[1],1240,680);
                else
                    image(img_sound[0],1240,680);
            }
        break;
    }
}
