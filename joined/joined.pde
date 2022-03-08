PegInHole win;
PGraphics pg;

import processing.video.*;

Capture video;
PImage prev;

float threshold = 25;

float motionX = 0;
float motionY = 0;

float lerpX = 0;
float lerpY = 0;

// For PegInHole
float angle_1 = 0.0;
float angle_2 = 0.0;

PShape piece;
  
float s1x = 0;      
float s1y = 0;
float s1w = 50;     
float s1h = 100;

float s2x = 0;    
float s2y = 350;
float s2w = 260;
float s2h = 480;

float s3x = 330;    
float s3y = 350;
float s3w = 640;
float s3h = 480;

float s4x = 250;    
float s4y = 420;
float s4w = 340;
float s4h = 480;


public void settings() {
  size(640, 480);
}

void setup() { 
  win = new PegInHole();
  pg = createGraphics(width, height);
  println(width, height);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[1]);
  video.start();
  prev = createImage(640, 480, RGB);
}

void captureEvent(Capture video) {
  prev.copy(video, 0, 0, video.width, video.height, 0, 0, prev.width, prev.height);
  prev.updatePixels();
  video.read();
}

void draw() {
  video.loadPixels();
  prev.loadPixels();
  image(video, 0, 0);
  
  threshold = 50;

  int count = 0;
  
  float avgX = 0;
  float avgY = 0;

  loadPixels();
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d > threshold*threshold) {
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }
  updatePixels();
  if (count > 200) { 
    motionX = avgX / count;
    motionY = avgY / count;
  }
  lerpX = lerp(lerpX, motionX, 0.1); 
  lerpY = lerp(lerpY, motionY, 0.1); 
  
  fill(255);
  strokeWeight(2.0);
  stroke(0);
  rectMode(CENTER);
  rect(lerpX, lerpY, 120, 200);
  ellipse(lerpX,lerpY,12,12);

  //image(video, 0, 0, 100, 100);
  //image(prev, 100, 0, 100, 100);

  //println(mouseX, threshold);
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}


class PegInHole extends PApplet {
  PGraphics pg1;

  PegInHole() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(640, 480);
  }

  void setup() {
    pg1 = createGraphics(width, height);
    println(width, height);
  }

  void setPG(PGraphics pg1) {
    pg1.beginDraw();
    this.pg1=pg1;
    pg1.endDraw();
  }

  void draw() {
drawSurface();
angle_1 = atan2(lerpY - 160, 150) - HALF_PI;
drawFirstArm();
angle_2 = atan2(320, lerpX - 200) - HALF_PI;
drawSecondArm();
drawPiece();
//s1x = (295 - 240*(1-cos(angle_1)) - 100*sin(angle_2));
//s1y = (300 + 240*sin(angle_1) - 100*(1-cos(angle_2)));
//rect(s1x,s1y,s1w+10,s1h+10);
// if hit, change rectangle color
boolean hit = rectRect(s1x,s1y,s1w,s1h, s2x,s2y,s2w,s2h);
if (hit) {
  fill(255,150,0);
}
else {
  fill(173,216,230);
}
rect(s2x,s2y,s2w,s2h);
rect(s3x,s3y,s3w,s3h);
rect(s4x,s4y,s4w,s4h);

}
void drawSurface()
{
background(255);
fill(173,216,230);
noStroke();

}

void drawFirstArm() {
stroke(100);
strokeWeight(10);
pushMatrix();
translate(80,200);
rotate(angle_1);
line(0,0,240,0);
popMatrix();
}

void drawSecondArm() {
stroke(100);
strokeWeight(10);
pushMatrix();
translate(320,200);
translate(-240*(1-cos(angle_1)),240*sin(angle_1));
rotate(angle_2);
line(0,0,0,120);
popMatrix();
}

void drawPiece() {
noStroke();
fill(173,216,230);
pushMatrix();
translate(295,300);
translate(-240*(1-cos(angle_1)),240*sin(angle_1));
translate(-100*sin(angle_2),-100*(1-cos(angle_2)));
rotate(angle_2);
piece = createShape(RECT,0, 0, s1w, s1h);
shape(piece,0,0);
s1x = screenX(0, 0);
s1y = screenY(0, 0);
popMatrix();
}

boolean rectRect(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {

// are the sides of one rectangle touching the other?

if (r1x + r1w >= r2x &&    // r1 right edge past r2 left
    r1x <= r2x + r2w &&    // r1 left edge past r2 right
    r1y + r1h >= r2y &&    // r1 top edge past r2 bottom
    r1y <= r2y + r2h) {    // r1 bottom edge past r2 top
      return true;
}
return false;
}
}
