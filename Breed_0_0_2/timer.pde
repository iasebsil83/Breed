// ---------------- Initialisation ----------------
final int mother_terrain_max = 7*WIDTH/8;



// ---------------- Execution -----------------
void timedEvents(){
    
    //terrain scroll
    if(mother.x > mother_terrain_max){
        ground_deltaX += 4;
        if(ground_deltaX+width-1 > ground_max_generated){
            generateNext();
            generateNext();
            generateNext();
            generateNext();
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
