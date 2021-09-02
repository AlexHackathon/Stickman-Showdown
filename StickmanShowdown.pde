//To Do: Add a scoreboard
import processing.serial.*;
//import cc.arduino.*;
//import java.lang.Math;
//import java.util.Random;
//Arduino arduino;
int stickMenPos;

int gameState;
boolean gameStateFinished;

boolean backSlash;
boolean finishedSlash;

int usedFrames;
boolean playerWon;

//Random rand;
int speed;
int startGreen;
float greenLength;

float distFromEdge = 200;

killerStickman player = new killerStickman(distFromEdge, 200, 25, 1, false);
killerStickman computer = new killerStickman(1200 - distFromEdge - stickMenPos, 200, 25, -1, false);

void setup(){
  //rand = new Random();
  background(0,0,0);
  stroke(255,255,255);
  size(1200,400);
  //stopMen = false;
  gameState = 0;
  gameStateFinished = true;
  finishedSlash = false;
  speed = 20;
  startGreen = int(random(4)) + 1;
  greenLength = random(1) + .2;
  //arduino = new Arduino(this,Arduino.list()[1], 57600);
}
void mouseClicked(){
  if(gameState == 0){
    gameState = 1;
    usedFrames = frameCount;
    backSlash = (random(1) >= .5);
  }else if(gameStateFinished && gameState == 3){
    //3 is waiting
    gameState = 1;
    reset();
  }
}
void draw(){
  //int y = arduino.analogRead(5);
  if(gameState == 0){
    fill(0,0,0);
    rect(0,0,1200,400);
    stroke(255,255,255);
    player.drawKillerStickman();
    computer.drawKillerStickman();
    if(7-((frameCount-(float)usedFrames)/60) >= startGreen-greenLength && 7-((frameCount-(float)usedFrames)/60) <=startGreen){
      fill(0,255,0);
      text(7-((frameCount-(float)usedFrames)/60), 600,59);
      playerWon = true;
    } else {
      fill(255,0,0);
      text(7-((frameCount-(float)usedFrames)/60), 600,59);
      playerWon = false;
    }
    fill(255,255,255);
  } else if(gameState == 1){
    fill(0,0,0,30);
    rect(0,0,1200,400);
    stickMenPos = (frameCount - usedFrames)* speed;
    player.moveKillerStickman(stickMenPos);
    computer.moveKillerStickman(1200-stickMenPos);
    player.drawKillerStickman();
    computer.drawKillerStickman();
    if(backSlash){
      if(stickMenPos > 1100){
        gameState = 2;
      }
    } else {
      if(stickMenPos > 300){
        gameState = 2;
      }
    }
  } else if(gameState == 2){
    fill(0,0,0,30);
    rect(0,0,1200,400);
    if(!finishedSlash){
      if(playerWon){
        player.drawSlash(computer,.5);
        computer.isDead = true;
      } else {
        computer.drawSlash(player,.5);
        player.isDead = true;
      }
      finishedSlash = true;
      usedFrames = frameCount;
    }
    player.drawKillerStickman();
    computer.drawKillerStickman();
    if((frameCount - usedFrames)/60.0 >= .2){
      gameState = 3;
    }
  } else if(gameState == 3){
    fill(0,0,0);
    rect(0,0,1200,400);
    fill(255,255,255);
    if(playerWon){
      text("You Win!!!", 600,59);
    } else {
      text("You Lose.", 600,59);
    }
    fill(0,0,0);
    stroke(255,255,255);
    player.drawKillerStickman();
    computer.drawKillerStickman();
  }
}
private void reset(){
  background(255,255,255);
  size(1200,400);
  fill(0,0,0);
  rect(0,0,1200,400);
  finishedSlash = false;
  usedFrames = frameCount;
  player.isDead = false;
  computer.isDead = false;
  gameState = 0;
  player.moveKillerStickman(distFromEdge);
  computer.moveKillerStickman(1200-distFromEdge);
  startGreen = int(random(4)) + 1;
  greenLength = random(1) + .2;
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
