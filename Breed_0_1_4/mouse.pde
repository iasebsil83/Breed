// ---------------- Initialisation ----------------
//movements
final int mouse_vector_min = 2;
int mouse_vectorX;
int mouse_vectorY;



// ---------------- Execution -----------------
void mousePressed(){
    switch(menu){
        case START:
            if(mouseButton == LEFT){
                
                //play button
                if(inZone(mouseX,mouseY, 420,435, 715,480)){
                    menu = menu_names.GAME;
                    musicCheck();
                    delay(1000);
                
                //mouse on exit button
                }else if(inZone(mouseX,mouseY, 525,565, 825,605))
                    exit();
                else if(inZone(mouseX,mouseY, 920,565, 960,605)){ //sound switch
                    snd_on = !snd_on;
                    musicCheck();
                    delay(100);
                }
            }
        break;
        case GAME:
            if(mouseButton == LEFT){
                
                //sound button
                if(mouseX > width-40 && mouseY > height-40){
                    snd_on = !snd_on;
                    musicCheck();
                    delay(400);
                }
                
            }else if(mouseButton == RIGHT){
                
                //mother turtle eat
                if(mother.adult && mother.sharkCnt == 0)
                    mother.attack();
            }
        break;
        case END:
            if(mouseButton == LEFT){
                
                //replay button
                if(inZone(mouseX,mouseY, 420,380, 830,465)){
                    //reset game
                    initTurtles();
                    menu = menu_names.GAME;
                    
                //quit button
                }else if(inZone(mouseX,mouseY, 445,515, 790,600))
                    exit();
            }
        break;
    }
}

void mouseReleased(){
    keys_text = "";
}

void mouseMoved(){
    
    //set mouse vector
    mouse_vectorX = mouseX-pmouseX;
    mouse_vectorY = mouseY-pmouseY;
    if(abs(mouse_vectorX) <= mouse_vector_min)
        mouse_vectorX = 0;
    if(abs(mouse_vectorY) <= mouse_vector_min)
        mouse_vectorY = 0;
    
    switch(menu){
        case START:
        break;
        case GAME:
        
            //mother follows mouse
            mother.vectorX = mouse_vectorX;
            mother.vectorY = mouse_vectorY;
            if(mouse_vectorX == 0 && mouse_vectorY == 0)
                mother.speed = 0;
            else
                mother.speed = 1;
            
        break;
        case END:
        break;
    }
}
