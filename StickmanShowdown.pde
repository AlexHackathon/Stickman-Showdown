import processing.serial.*;
import cc.arduino.*;
import java.lang.Math;
import java.util.Random;
//Arduino arduino;
int stickMenPos;
boolean stopMen;
boolean finishedSlash;
int usedFrames;

Random rand;
int speed;

killerStickman player = new killerStickman(stickMenPos, 200, 25, 1, false);
killerStickman computer = new killerStickman(1200 - stickMenPos, 200, 25, -1, false);

void setup(){
  rand = new Random();
  background(0,0,0);
  stroke(255,255,255);
  size(1200,400);
  stopMen = false;
  finishedSlash = false;
  speed = rand.nextInt(10) + 5;
  //arduino = new Arduino(this,Arduino.list()[1], 57600);
}
void mouseClicked(){
  if(!stopMen){
    stopMen = true;
  } else {
    reset();
  }
}
void draw(){
  //int y = arduino.analogRead(5);
  fill(0,0,0,30);
  rect(0,0,1200,400);
  player.moveKillerStickman(stickMenPos);
  computer.moveKillerStickman(1200-stickMenPos);
  //300 to 1000 is good
  //Anything else is a draw
  if(!stopMen){
    stickMenPos = (frameCount - usedFrames)* speed;
    if(stickMenPos > 1100){
      stopMen = true;
    }
  } else {
    if(!finishedSlash){
      if(stickMenPos >= 400 && stickMenPos <= 900){
        player.drawSlash(computer,.5);
        computer.isDead = true;
      } else {
        computer.drawSlash(player,.5);
        player.isDead = true;
      }
      finishedSlash = true;
    }
  }
  player.drawKillerStickman();
  computer.drawKillerStickman();
}
private void reset(){
  background(255,255,255);
  size(1200,400);
  fill(255,255,255);
  rect(0,0,1200,400);
  stopMen = false;
  finishedSlash = false;
  usedFrames = frameCount;
  player.isDead = false;
  computer.isDead = false;
  speed = rand.nextInt(10) + 5;
}
public class killerStickman{
  //Instance variables
  float posX;
  float posY;
  float baseUnit;
  int facingDirection;
  boolean isDead;
  float swordPosX;
  float swordPosY;
  public killerStickman(float posX, float posY, float baseUnit, int facingDirection, boolean isDead){
    this.posX = posX;
    this.posY = posY;
    this.baseUnit = baseUnit;
    this.facingDirection = facingDirection;
    this.isDead = isDead;
    this.swordPosX = this.posX - 1.5*this.baseUnit*this.facingDirection;
    this.swordPosY = this.posY + 3*this.baseUnit*this.facingDirection;
  }
  public void drawKillerStickman(){
    //Spine
    line(this.posX, this.posY, this.posX-2 * this.baseUnit * this.facingDirection, this.posY + 4* this.baseUnit);
    //Head
    if(!isDead){
      ellipse(this.posX, this.posY, 2* this.baseUnit, 2* this.baseUnit);
    } else {
      ellipse(this.posX+2* this.baseUnit * this.facingDirection, this.posY + 5*baseUnit, 2* this.baseUnit, 2* this.baseUnit);
    }
    //Sword Arm
    line(this.posX-this.baseUnit*this.facingDirection, this.posY + 2*this.baseUnit, this.posX-3*this.baseUnit*this.facingDirection, this.posY+2*this.baseUnit);
    line(this.posX-3*this.baseUnit *this.facingDirection, this.posY+2*this.baseUnit, this.posX-1.5*this.baseUnit*this.facingDirection, this.posY + 3*this.baseUnit);
    //Legs
    //Front
    line(this.posX-2*this.baseUnit*this.facingDirection, this.posY+4*this.baseUnit, this.posX, this.posY+4*this.baseUnit);
    line(this.posX, this.posY+4*this.baseUnit, this.posX-this.baseUnit*this.facingDirection, this.posY + 6 * this.baseUnit);
    //Back
    line(this.posX-2*this.baseUnit*this.facingDirection, this.posY + 4*this.baseUnit, this.posX - 5 * this.baseUnit*this.facingDirection, this.posY + 6*this.baseUnit);
    //Sword
    line(this.posX+this.baseUnit*this.facingDirection, this.posY+2* this.baseUnit, this.posX-8*this.baseUnit*this.facingDirection, this.posY+6*this.baseUnit);
  }
  public void moveKillerStickman(float posX){
    this.posX = posX;
    this.swordPosX = this.posX - 1.5*this.baseUnit*this.facingDirection;
  }
  public void drawSlash(killerStickman opponent, float fractionOfPi){
    stroke(255,0,0);
    double unrootedDist = Math.pow(this.swordPosX-opponent.posX,2) + Math.pow(this.swordPosY-opponent.posY,2);
    float dist = (float)Math.sqrt(unrootedDist);
    //Use fractionOfPi to draw arcs one by one to create a circle fade effect
    ellipse(this.swordPosX,this.swordPosY,2*dist,2*dist);
    stroke(255,255,255);
  }
}
