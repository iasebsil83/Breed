// ---------------- Initialisation ----------------
Minim minim;
AudioPlayer snd_menu;
AudioPlayer[] snd_game = new AudioPlayer[4];
AudioPlayer snd_scrshot;
byte musicSel = (byte)random(4);
boolean snd_on = true;

void initSounds(){
    minim = new Minim(this);
    //sounds
    snd_scrshot = minim.loadFile("sounds/sounds/screenshot.mp3");
    
    //musics
    snd_menu = minim.loadFile("sounds/musics/menu.mp3");
    for(byte a=0; a < 4; a++){
        snd_game[a] = minim.loadFile("sounds/musics/game" + a + ".mp3");
        snd_game[a].setGain(-5);
    }
    snd_menu.loop();
}



// ---------------- Execution ----------------
void soundCheck(){
    if(snd_on){
        switch(menu){
            case START:
                if(!snd_menu.isPlaying()){
                    snd_menu.rewind();
                    snd_menu.loop();
                }
                if(snd_game[musicSel].isPlaying())
                    snd_game[musicSel].pause();
            break;
            case GAME:
                if(!snd_game[musicSel].isPlaying()){
                    musicSel = (byte)random(snd_game.length);
                    snd_game[musicSel].rewind();
                    snd_game[musicSel].play();
                }
                if(snd_menu.isPlaying())
                    snd_menu.pause();
            break;
        }
    }else{
        if(snd_menu.isPlaying())
            snd_menu.pause();
        for(byte a=0; a < snd_game.length; a++)
            if(snd_game[a].isPlaying())
                snd_game[a].pause();
    }
}
