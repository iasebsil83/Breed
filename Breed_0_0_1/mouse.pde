// ---------------- Initialisation ----------------
final int mouse_vector_min = 2;
int mouse_vectorX;
int mouse_vectorY;



// ---------------- Functions ----------------



// ---------------- Execution -----------------
void mousePressed(){
    switch(menu){
        case START:
            if(mouseButton == LEFT){
                
                //play button
                if(mouseY > 435 && mouseY < 480){
                    if(mouseX > 420 && mouseX < 715){
                        menu = menu_names.GAME;
                        soundCheck();
                        delay(1000);
                    }
                
                //mouse on exit button
                }else if(mouseY > 565 && mouseY < 605){
                    if(mouseX > 525 && mouseX < 825)
                        exit();
                    else if(mouseX > 920 && mouseX < 960){ //sound switch
                        snd_on = !snd_on;
                        soundCheck();
                        delay(100);
                    }
                }
            }
        break;
        case GAME:
            //
        break;
    }
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
            //
        break;
        case GAME:
        
            //mother follows mouse
            mother.tryMove(mouseX,mouseY);
            mother.vectorX = mouse_vectorX;
            mother.vectorY = mouse_vectorY;
            if(mouse_vectorX == 0 && mouse_vectorY == 0)
                mother.speed = 0;
            else
                mother.speed = 1;
            
        break;
    }
}
