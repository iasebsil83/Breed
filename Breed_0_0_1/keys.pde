// ---------------- Functions -----------------



// ---------------- Execution ----------------
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
                case 's':
                case 'S':
                    snd_on = !snd_on;
                    soundCheck();
                    delay(100);
                break;
            }
        break;
        case GAME:
            switch(key){ //WARNING : working on AZERTY keyboard only !
                case '<': //toggle sound
                    snd_on = !snd_on;
                    soundCheck();
                    delay(400);
                break;
                case '=': //take screenshot
                    //screenshot sound
                    snd_scrshot.rewind();
                    snd_scrshot.play();
                    
                    //take screenshot
                    save("screenshots/Breed_Screenshot" + screenshotNbr + ".png");
                    screenshotNbr++;
                    display_screenshotCnt = 15;
                break;
                case 'm': //go bac to start_menu
                    menu = menu_names.START;
                    soundCheck();
                    delay(100);
                break;
                case 'g': //get saved scene
                    loadGame();
                    delay(100);
                break;
                case 't': //save scene
                    saveGame();
                break;
            }
        break;
    }
}
