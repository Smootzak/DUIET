//*********************************************
// Example Code: ArUCo Fiducial Marker Detection in OpenCV Python and then send to Processing via OSC
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import oscP5.*;
import netP5.*;
import processing.net.*;

import processing.sound.*;
SoundFile file;
PImage imgForward;
PImage imgNormal;
PImage imgBack;

TagManager tm;
OscP5 oscP5;

float Speed = 1;

//camera parameters
int camWidth = 1280; //camera resolution (width)
int camHeight = 720; //camera resolution (height)
boolean camFlipped = true; //is camera image flipped horizontally?

//list of active tags
ArrayList<Tag> activeTagList = new ArrayList<Tag>();

//example data objects
int[] dataObjects = new int[12];

void setup() {
  size(190, 206); //initialize canvas
  oscP5 = new OscP5(this, 9000); //initialize OSC connection via port 9000
  initTagManager(); //initialize tag manager
  
    // Load a soundfile from the data folder
  file = new SoundFile(this, "lofi-study-beat-1-245772.mp3"); //Music by officeMIKADO from Pixabay
  file.loop();
  
  //Load images
  imgForward = loadImage("LeaningForward.jpg");
  imgNormal = loadImage("LeaningNormal.jpg");
  imgBack = loadImage("LeaningBack.jpg");
}

void draw() {
  tm.update(); //update the tag manager and the states of tags.
  updateActiveTags(); //update the list of active tags
  
  //visualization
  background(255); //refresh the background
  tm.displayRaw(camFlipped); //draw raw data according to camFlipped
 
  
  // Track tag0 specifically and display its position and rotation
  for (Tag t : activeTagList) {
    if (t.id == 0) {  // Only trace tag0
      showTag0Info(t.tx, t.ty, t.tz, t.rx, t.ry, t.rz); // Display info on screen
      Song(t.tx, t.ty, t.tz, t.rx, t.ry, t.rz);
    }
  }
  
  file.rate(Speed); // play song
  
}

void updateActiveTags(){
  activeTagList.clear();
  for(int tagIndex: tm.activeTags){
    activeTagList.add(tm.tags[tagIndex]);
  }
}

//void showInfo(String s,int x, int y){
//  pushStyle();
//  fill(52);
//  textAlign(LEFT, BOTTOM);
//  textSize(48);
//  text(s, x, y);
//  popStyle();
//}


void Song(float tx, float ty, float tz, float rx, float ry, float rz) {
  if ( tz > 0.50 && tz < 0.76){
    Speed = 1;
    image(imgNormal, 0, 0, width, height - 16);
  }
  if ( tz < 0.50){
    Speed = 1 - (tz - 0.50); //Song goes faster
    image(imgForward, 0, 0, width, height - 16);
  }
  if ( tz > 0.76){
    Speed = 1 - (tz - 0.76); //Song goes slower
    image(imgBack, 0, 0, width, height - 16);
  }
}

void showTag0Info(float tx, float ty, float tz, float rx, float ry, float rz) {
  pushStyle();
  if ( tz > 0.50 && tz < 0.76){
    fill(49, 96, 61); // Green text to make it stand out
  }
  else{
    fill(210, 61, 45); // Red text to make it stand out
  }
  
  textAlign(CENTER, TOP);
  textSize(16);
  
  // Display tag's position
  text("Position: " + int(tz * 100) + " CM from screen", 95, 190);
  
  
  popStyle();
}
  
  
