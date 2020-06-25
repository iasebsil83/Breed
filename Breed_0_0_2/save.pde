// ---------------- Initialisation ----------------



// ---------------- Functions ----------------
void saveGame(){
    PrintWriter f = createWriter("scene.sav");
    f.println("0,1,2,3,4,5,6,7");
    f.flush();
    f.close();
    println("Scene saved !");
    delay(100);
}

void loadGame(){
    BufferedReader reader = createReader("Breed_save.sav");
    String line = null;
    byte SCENE_LENGTH = 8;
    byte[] scene = new byte[SCENE_LENGTH];
    try{
        while( (line = reader.readLine()) != null){
            String[] pieces = split(line, ",");
            if(pieces.length == 0 || pieces.length-1 > SCENE_LENGTH){
                println("Unable to load save file");
                break;
            }
            for(byte a=0; a < pieces.length-1; a++)
                scene[a] = Byte.parseByte(pieces[a]);
        }
        reader.close();
    }catch(IOException e){
      println("Unable to load save file");
    }
}
