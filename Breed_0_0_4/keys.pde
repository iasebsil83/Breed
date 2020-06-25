// ---------------- Initialisation ----------------



// ---------------- Execution ---------------- //WARNING : working correctly on AZERTY keyboard only !
void keyPressed(){
    switch(menu){
        case START:
            switch(key){
                case 'p':
                case 'P':
                    //play
                    menu = menu_names.GAME;
                    soundCheck();
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
                    soundCheck();
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
                    soundCheck();
                    delay(400);
                break;
                case 'q':
                case 'Q':
                    exit();
                break;
                case '=':
                case '+':
                    //screenshot sound
                    snd_scrshot.rewind();
                    snd_scrshot.play();
                    
                    //take screenshot
                    save("screenshots/Breed_Screenshot" + screenshotNbr + ".png");
                    screenshotNbr++;
                    display_screenshotCnt = 15;
                break;
            }
        break;
        case END:
            switch(key){
                case '<':
                case '>':
                    //toggle sound
                    snd_on = !snd_on;
                    soundCheck();
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
