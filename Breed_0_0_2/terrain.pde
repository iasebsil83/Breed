// ---------------- Initialisation ----------------
final float ground_diff_max = 1;
final int ground_width_buffer_length = 10;
color ground_color;
int[] ground_height;
int[] ground_amp;
float[] ground_freq;
int ground_max_generated = 0;
int ground_deltaX = 0;



// ---------------- Functions ----------------
void initGround(){
    
    //init variables
    ground_color = color(230,210,200);
    ground_amp    = new int  [ground_width_buffer_length*width];
    ground_freq   = new float[ground_width_buffer_length*width];
    ground_height = new int  [ground_width_buffer_length*width];
    
    //set first values
    ground_amp[0] = (int)(height*0.7);
    ground_freq[0] = 0.01;
    ground_height[0] = height+10;
    
    //generate first screen
    for(int x=1; x < width; x++)
        generateNext();
}

void generateNext(){
    
    //get previous values
    int amp = ground_amp[ground_max_generated];
    float freq = ground_freq[ground_max_generated];
    
    ground_max_generated++;
    
    //ground buffer is full
    if(ground_max_generated == ground_width_buffer_length*width){
        ground_deltaX--;
        ground_max_generated--;
        return;
    }

    //set new height
    if(random(1) < 0.5)
        amp++;
    else
        amp--;
    amp += 2*random(1001)/1000;
    if(amp < height_12)
        amp += 2;
    if(amp > height_8)
        amp -= 2;
    if(random(1) < 0.5)
        freq += 0.00006;
    else
        freq -= 0.00006;
    
    //set new values
    ground_amp[ground_max_generated] = amp;
    ground_freq[ground_max_generated] = freq;
    ground_height[ground_max_generated] = (int)( height_4 + amp*cos(freq*ground_max_generated) );
    
    //smoothing a bit
    for(int n=1; n < 4; n++){
        if(ground_max_generated-n < 0)
            break;
        if(
            abs(
                ground_height[ground_max_generated-n] -
                ground_height[ground_max_generated  ]
            )
            > ground_diff_max
        )
            ground_height[ground_max_generated] = (
                2*ground_height[ground_max_generated-n] + ground_height[ground_max_generated]
            )/3;
    }
}
