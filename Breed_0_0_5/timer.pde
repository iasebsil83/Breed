// ---------------- Initialisation ----------------
final int mother_terrain_max = 7*WIDTH/8;
final int mother_terrain_min = WIDTH/8;



// ---------------- Execution -----------------
void timedEvents(){
    switch(menu){
        case START:
        break;
        case GAME:
            //terrain scroll
            motherTerrainScroll();
            
            //mother turtle
            mother.tryMove(mouseX,mouseY);
            mother.update();
            if(!mother.alive){ //mother died
                int maxAge = -1;
                byte maxAgeIndex = -1;
                for(byte c=0; c < CHILDREN_LENGTH; c++){
                    if(children[c].alive && children[c].age > maxAge){
                        maxAge = children[c].age;
                        maxAgeIndex = c;
                    }
                }
                if(maxAgeIndex == -1)
                    menu = menu_names.END;
                else{
                    //children become mother
                    mother.setAttributesFrom(children[maxAgeIndex]);
                    mother.alive = true;
                    children[maxAgeIndex].alive = false;
                }
            }
            
            //children turtles
            for(byte c=0; c < CHILDREN_LENGTH; c++){
                
                //alive or not
                if(!children[c].alive)
                    continue;
                
                //randomly moving
                children[c].x += random(4)-2;
                children[c].y += random(4)-2;
                
                //follow mother
                children[c].vectorX = mother.x - children[c].x;
                children[c].vectorY = mother.y - children[c].y;
                float turtle_distance = sqrt((float)(
                    children[c].vectorX*children[c].vectorX +
                    children[c].vectorY*children[c].vectorY
                ));
                if(turtle_distance > turtle_distance2mother)
                    children[c].speed += turtle_distance*(
                        turtle_childrenSpeed + turtle_childSpeed*children[c].distance
                    );
                children[c].update();
            }
            
            
            //music looping
            snd_musicCnt++;
            if(snd_musicCnt == snd_musicCntMax){
                soundCheck();
                snd_musicCnt = 0;
            }
            
        break;
        case END:
        break;
    }
}
