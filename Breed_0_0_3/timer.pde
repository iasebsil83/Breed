// ---------------- Initialisation ----------------
final int mother_terrain_max = 7*WIDTH/8;
final int mother_terrain_min = WIDTH/8;



// ---------------- Execution -----------------
void timedEvents(){
    
    //terrain scroll
    if(mother.x > mother_terrain_max){
        gnd_deltaX += 16;
        if(gnd_deltaX+width > gnd_buffer_len){
            println("getting next half buffer...");
            saveHalfBuffer(0);
            gnd_prevLand++;
            gnd_nextLand++;
            gnd_deltaX -= gnd_buffer_len_2;
            leftShiftBuffer();
            println("    <Info : " + gnd_prevLand + " , " + gnd_nextLand + " >");
            getHalfBuffer(gnd_buffer_len_2);
            println("...done");
        }
    }else if(mother.x < mother_terrain_min){
        gnd_deltaX -= 16;
        if(gnd_deltaX < 0){
            println("getting prev half buffer...");
            saveHalfBuffer(gnd_buffer_len_2);
            gnd_prevLand--;
            gnd_nextLand--;
            gnd_deltaX += gnd_buffer_len_2;
            rightShiftBuffer();
            println("    <Info : " + gnd_prevLand + " , " + gnd_nextLand + " >");
            getHalfBuffer(0);
            println("...done");
        }
    }
    
    //mother turtle
    mother.tryMove(mouseX,mouseY);
    mother.update();
    
    //children turtles
    for(byte c=0; c < CHILDREN_LENGTH; c++){
        
        //randomly moving
        children[c].x += random(2)-1;
        children[c].y += random(2)-1;
        
        //follow mother
        children[c].vectorX = mother.x - children[c].x;
        children[c].vectorY = mother.y - children[c].y;
        float turtle_distance = sqrt((float)(
            children[c].vectorX*children[c].vectorX +
            children[c].vectorY*children[c].vectorY
        ));
        if(turtle_distance > 60)
            children[c].speed += turtle_distance*(0.0004 + 0.000035*children[c].distance);
        children[c].update();
    }
}
