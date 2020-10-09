// ---------------- Initialisation ----------------
//turtles random movements
final int turtles_randomMoveCntMax = 5;
int turtles_randomMoveCnt = 0;



// ---------------- Execution -----------------
void timedEvents(){
    switch(menu){
        case START:
        break;
        case GAME:
            //terrain scroll
            terrainScroll();
            
            //mother follows mouse
            if(mother.fireCnt > 0)
                mother.tryMove(
                    (int)(mouseX+random(44)-22), (int)(mouseY+random(44)-22),
                    turtle_adult_hitboxX, turtle_adult_hitboxY
                );
            else
                mother.tryMove(
                    mouseX,mouseY,
                    turtle_adult_hitboxX, turtle_adult_hitboxY
                );
            
            //mother update
            mother.update();
            if(!mother.alive){ //mother died
                int maxAge = -1;
                byte maxAgeIndex = -1;
                for(byte c=0; c < childrenLen; c++){
                    if(children[c].alive && children[c].age > maxAge){
                        maxAge = children[c].age;
                        maxAgeIndex = c;
                    }
                }
                if(maxAgeIndex == -1){
                    menu = menu_names.END;
                    if(score > bestScore)
                        bestScore = score;
                }else{
                    //children become mother
                    mother.setAttributesFrom(children[maxAgeIndex]);
                    mother.alive = true;
                    children[maxAgeIndex].alive = false;
                }
            }
            
            //children turtles
            for(byte c=0; c < childrenLen; c++){
                //randomly moving
                if(turtles_randomMoveCnt <= 0){
                    children[c].x += random(4)-1.9999;
                    children[c].y += random(4)-1.9999;
                }
                
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
            
            //mother randomly moving
            if(turtles_randomMoveCnt <= 0){
                mother.x += random(2) - 0.9999;
                mother.y += random(2) - 0.9999;
                turtles_randomMoveCnt = turtles_randomMoveCntMax;
            }
            turtles_randomMoveCnt--;
            
            //passive entities
            for(int e=0; e < passive_entitiesLen; e++){
                if(passive_entities[e].x >= gnd_deltaX && passive_entities[e].x < width+gnd_deltaX)
                    passive_entities[e].update(e);
            }
            
            //hostile entities
            for(int e=0; e < hostile_entitiesLen; e++){
                if(hostile_entities[e].x >= gnd_deltaX && hostile_entities[e].x < width+gnd_deltaX)
                    hostile_entities[e].update(e);
            }
            
            //spawn entity
            if(random(10) > 9.0)
                spawnEntity();
            
            //music looping
            snd_musicCnt++;
            if(snd_musicCnt == snd_musicCntMax){
                musicCheck();
                snd_musicCnt = 0;
            }
        break;
        case END:
        break;
    }
}
