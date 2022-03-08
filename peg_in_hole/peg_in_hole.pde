float angle_1 = 0.0;
float angle_2 = 0.0;

PShape shape; 

void setup()
{
  size(640, 480);
  
}

void draw() {
  drawSurface();
  angle_1 = atan2(mouseY - 160, 150) - HALF_PI;
  drawFirstArm();
  angle_2 = atan2(320, mouseX - 200) - HALF_PI;
  drawSecondArm();
  drawPiece();
  float[] p = shape.getParams();
  print(p);
  
}
void drawSurface()
{
  background(255);
  fill(173,216,230);
  noStroke();
  rect(0,350,260,480);
  rect(330,350,640,480);
  rect(250,420,340,480);
  
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
  shape = createShape(RECT,0, 0, 50, 100);
  shape(shape,0,0);
  popMatrix();
  // pushMatrix();
  // translate(320, 240);
  // rotate(angle);
  // popMatrix();
}
