// ---------------- Initialisation ----------------
//other functionalities
String keys_text = "";
boolean enable_n = false;
boolean enable_l = false;
boolean enable_s = false;
boolean enable_a = false;
boolean enable_f = false;
//color for n
int nRed   = 150;
int nGreen = 150;
int nBlue  = 150;



// ---------------- Execution ---------------- //WARNING : working correctly on AZERTY keyboard only !
void keyPressed(){
    switch(menu){
        case START:
            switch(key){
                case 'p':
                case 'P':
                    //play
                    menu = menu_names.GAME;
                    musicCheck();
                    delay(1000);
                break;
                case 'q':
                case 'Q':
                    exit();
                break;
                case '<':
                case '>':
                    //toggle sound
                    snd_on = !snd_on;
                    musicCheck();
                    delay(100);
                break;
            }
        break;
        case GAME:
            switch(key){
                case '<':
                case '>':
                    //toggle sound
                    snd_on = !snd_on;
                    musicCheck();
                    delay(400);
                break;
                case 'q':
                case 'Q':
                    exit();
                break;
                case '=':
                case '+':
                    //screenshot sound
                    if(snd_on)
                        snd_play(snd_scrshot);
                    
                    //take screenshot
                    save("screenshots/Breed_Screenshot" + screenshotNbr + ".png");
                    screenshotNbr++;
                    display_screenshotCnt = 15;
                break;
                default:
                    //other functionalities
                    if(mousePressed && mouseButton == LEFT){
                        keys_text += Character.toString(key).toUpperCase();
                        delay(100);
                    }
                    if(keys_text.contains("NINJA")){
                        enable_n = !enable_n;
                        println("[TURTLES CHEAT CODE] : Toggle ninja skin");
                    }
                    if(keys_text.contains("LIFE")){
                        enable_l = !enable_l;
                        println("[TURTLES CHEAT CODE] : Toggle infinite life regeneration");
                    }
                    if(keys_text.contains("SHARK")){
                        enable_s = !enable_s;
                        if(enable_s)
                            mother.sharkCnt = turtle_sharkCntMax;
                        else
                            mother.sharkCnt = 0;
                        println("[TURTLES CHEAT CODE] : Toggle infinite shark transormation");
                    }
                    if(keys_text.contains("TIME")){
                        enable_a = !enable_a;
                        println("[TURTLES CHEAT CODE] : Toggle time passing");
                    }
                    if(keys_text.contains("FIRE")){
                        enable_f = !enable_f;
                        if(enable_f)
                            mother.fireCnt = turtle_fireCntMax;
                        else
                            mother.fireCnt = 0;
                        println("[TURTLES CHEAT CODE] : Toggle infinite fire");
                    }
            }
        break;
        case END:
            switch(key){
                case '<':
                case '>':
                    //toggle sound
                    snd_on = !snd_on;
                    musicCheck();
                    delay(400);
                break;
                case 'r':
                case 'R':
                    //reset game
                    initTurtles();
                    menu = menu_names.GAME;
                break;
                case 'q':
                case 'Q':
                    exit();
                break;
            }
        break;
    }
}



// ---------------- Execution ----------------
void nShakeColor(){
    //red
    if(random(1) > 0.5 && nRed > 110)
        nRed -= 4;
    if(random(1) > 0.5 && nRed < 254)
        nRed += 4;
    
    //green
    if(random(1) > 0.5 && nGreen > 110)
        nGreen -= 4;
    if(random(1) > 0.5 && nGreen < 254)
        nGreen += 4;
    
    //blue
    if(random(1) > 0.5 && nBlue > 110)
        nBlue -= 4;
    if(random(1) > 0.5 && nBlue < 254)
        nBlue += 4;
}
