// ---------------- Initialisation ----------------
//counter
final int snd_musicCntMax = 2000;
int snd_musicCnt = 0;

//sound motor
Minim minim;

//musics
AudioPlayer snd_menu;
AudioPlayer[] snd_game = new AudioPlayer[4];

//sounds
//screenshot
AudioPlayer snd_scrshot;
//turtles
AudioPlayer snd_attack;
AudioPlayer snd_looseLife;
AudioPlayer snd_breath;
//ambient
AudioPlayer snd_water;
//particles
AudioPlayer[] snd_bubbles = new AudioPlayer[8];
AudioPlayer snd_fire;

//options
byte musicSel = (byte)random(4);
boolean snd_on = true;

void initSounds(){
    //init
    minim = new Minim(this);
    
    //sounds
    //screenshot
    snd_scrshot   = minim.loadFile("sounds/sounds/screenshot.mp3");
    //turtles
    snd_attack    = minim.loadFile("sounds/sounds/attack.mp3"    );
    snd_looseLife = minim.loadFile("sounds/sounds/looseLife.mp3" );
    snd_breath    = minim.loadFile("sounds/sounds/breath.mp3"    );
    //ambient
    snd_water     = minim.loadFile("sounds/sounds/water.mp3"     );
    snd_water.setGain(-10);
    //particles
    for(byte a=0; a < snd_bubbles.length; a++)
        snd_bubbles[a] = minim.loadFile("sounds/sounds/bubbles" + a + ".mp3");
    snd_fire      = minim.loadFile("sounds/sounds/fire.mp3"      );
    
    //musics
    snd_menu = minim.loadFile("sounds/musics/menu.mp3");
    for(byte a=0; a < 4; a++){
        snd_game[a] = minim.loadFile("sounds/musics/game" + a + ".mp3");
        snd_game[a].setGain(-5);
    }
    snd_menu.loop();
}



// ---------------- Functions ----------------
void snd_play(AudioPlayer a){
    a.rewind();
    a.play();
}



// ---------------- Execution ----------------
void musicCheck(){
    if(snd_on){
        switch(menu){
            case START:
            case END:
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
                    snd_play(snd_game[musicSel]);
                }
                if(!snd_water.isPlaying()){
                    snd_water.rewind();
                    snd_water.loop();
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
            if(snd_water.isPlaying())
                snd_water.pause();
    }
}
