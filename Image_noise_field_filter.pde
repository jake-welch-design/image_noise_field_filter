/*

Image_noise_field_filter.pde by jakewelch.design

Controls:
'r' to inditialize filter
UP & DOWN keys to adjust noise amount
LEFT & RIGHT keys to adjust noise scale
SPACEBAR to pause & save a .png

*/

//video export library
import com.hamoid.*;
VideoExport videoExport;

//images
PImage img;
PImage offsetImg;

//vid export settings
int vidLength = 30;
int frames = 30;
int delay = 1;

//noise field settings
float noiseScale = 0.0; // Controls the scale of the noise field
float noiseAmount = 0; // Controls the amount of noise applied
float noiseTime = 0; // Time component for noise animation

//toggles for controls
boolean randomize = false;
boolean isPaused = false;

//text settings
PFont font;
int textSize = 50;
String txt = " ";

void setup() {
  size(1000, 1500);
  frameRate(frames);
  
  //load font
  font = createFont("IBMPlexMono-Text.ttf", textSize); //upload your own font

  //load image
  img = loadImage(" "); //upload your own image
  img.resize(width, 0);
  offsetImg = img.get();

  //initialize video export settings
  videoExport = new VideoExport(this, "video_export.mp4");
  videoExport.setFrameRate(frames);
  videoExport.startMovie();
  videoExport.setQuality(100, 0);
}

void draw() {
  //pause & save toggle
  if (isPaused) {
    saveFrame("image_export.png");
    return;
  }
  
  //image display
  imageMode(CENTER);
  translate(width * 0.5, height * 0.5);
  image(offsetImg, 0, 0);

  //noise field initialize & animate
  if (randomize) {
    offsetImg = offsetPixels(img);
    image(offsetImg, 0, 0);
    noiseTime += 0.01;
  }
  
  //grayscale filter for image, can remove for color if you want
  filter(GRAY);
  
  //text 
  fill(255, 0, 0);
  textFont(font);
  textSize(textSize);
  textAlign(CENTER, CENTER);
  text(txt, 0, 0);

  //video export 
  if (frameCount > delay) {
    videoExport.saveFrame();
  }
  if (frameCount >= (frames * vidLength) + delay) {
    exit();
  }
}

//noise field displacement function
PImage offsetPixels(PImage original) {
  PImage result = original.get();
  result.loadPixels();
  for (int i = 0; i < result.pixels.length; i++) {
    int x = i % result.width;
    int y = i / result.width;
    float offsetX = noise(x * noiseScale, y * noiseScale, noiseTime) * noiseAmount;
    float offsetY = noise((x + 1000) * noiseScale, (y + 1000) * noiseScale, noiseTime) * noiseAmount;
    int newX = (int) (x + offsetX) % result.width;
    int newY = (int) (y + offsetY) % result.height;
    color c = original.get(newX, newY);
    result.pixels[i] = c;
  }
  result.updatePixels();
  return result;
}

//keyboard controls function
void keyPressed() {
  if (key == 'r') {
    randomize = !randomize;
    noiseTime = 0; // Reset the noise time when 'r' is pressed
  }
  if (key == ' ') {
    isPaused = !isPaused;
    txt = " ";
  }
  if (keyCode == UP) {
    noiseAmount += 1;
    txt = "APPLYING\nNOISE FIELD" + "\n "+ "Noise amount: " + noiseAmount + "\n" + "Noise scale: " + noiseScale;
    textSize = 50;
  } else if (keyCode == DOWN) {
    noiseAmount -= 1;
    txt = "APPLYING\nNOISE FIELD" + "\n "+ "Noise amount: " + noiseAmount + "\n" + "Noise scale: " + noiseScale;
    textSize = 50;
  }
  if (keyCode == LEFT) {
    noiseScale -= 0.01; // Decrease noise scale
    txt = "APPLYING\nNOISE FIELD" + "\n "+ "Noise amount: " + noiseAmount + "\n" + "Noise scale: " + noiseScale;
    textSize = 50;
  } else if (keyCode == RIGHT) {
    noiseScale += 0.01; // Increase noise scale
    txt = "APPLYING\nNOISE FIELD" + "\n "+ "Noise amount: " + noiseAmount + "\n" + "Noise scale: " + noiseScale;
    textSize = 50;
  }
}
