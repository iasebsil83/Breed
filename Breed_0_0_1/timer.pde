void timedEvents(){
    //mother turtle
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
