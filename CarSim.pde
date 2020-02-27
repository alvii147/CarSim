Car myCar;
Controls myControls;

PImage carImage;
PImage steeringWheelImage;
PImage brakeImage;
PImage acceleratorImage;
PImage backgroundImage;

enum Gear
{
  P,
  R,
  N,
  D
}

Gear GEAR_MODE;

boolean ACC_KEY;
boolean BRAKE_KEY;
boolean STEER_LEFT;
boolean STEER_RIGHT;
float CAR_ACC;
float BRAKE_ACC;
float NATURAL_ACC;
float CAR_DEL_ANGLE;
float DRIVE_MODE_VEL;

void setup()
{
  size(941, 941);
  surface.setLocation(500, 40);
  
  imageMode(CENTER);
  carImage = loadImage("blueCar.png");
  steeringWheelImage = loadImage("steeringWheel.png");
  brakeImage = loadImage("brake.png");
  acceleratorImage = loadImage("accelerator.png");
  backgroundImage = loadImage("Town.jpg");
  
  myCar = new Car();
  myControls = new Controls();
  
  GEAR_MODE = Gear.P;
  
  ACC_KEY = false;
  BRAKE_KEY = false;
  STEER_LEFT = false;
  STEER_RIGHT = false;
  
  CAR_ACC = 0.15;
  BRAKE_ACC = -0.5;
  NATURAL_ACC = -0.01;
  CAR_DEL_ANGLE = 0;
  DRIVE_MODE_VEL = 0.4;
}

void draw()
{
  background(125);
  push();
  scale(0.97);
  image(backgroundImage, width/2, height/2);
  pop();
  
  if(GEAR_MODE == Gear.P)
  {
    if(abs(myCar.velMag) >= 0.3)
    {
      myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*BRAKE_ACC;
    }
    else
    {
      myCar.accMag = 0;
      myCar.velMag = 0;
    }
  }
  else if(GEAR_MODE == Gear.D)
  {
    if(ACC_KEY && !BRAKE_KEY)
    {
      myCar.accMag = CAR_ACC;
    }
    else if(BRAKE_KEY &&  !ACC_KEY)
    {
      if(abs(myCar.velMag) >= 0.3)
      {
        myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*BRAKE_ACC;
      }
      else
      {
        myCar.accMag = 0;
        myCar.velMag = 0;
      }
    }
    else if(abs(myCar.velMag) >= DRIVE_MODE_VEL)
    {
      myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*NATURAL_ACC;
    }
    else
    {
        myCar.accMag = 0;
        myCar.velMag = DRIVE_MODE_VEL;
    }
    
    if(myCar.velMag < 0)
    {
      myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*BRAKE_ACC;
    }
  }
  else if(GEAR_MODE == Gear.R)
  {
    if(ACC_KEY && !BRAKE_KEY)
    {
      myCar.accMag = -CAR_ACC;
    }
    else if(BRAKE_KEY && !ACC_KEY)
    {
      if(abs(myCar.velMag) >= 0.3)
      {
        myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*BRAKE_ACC;
      }
      else
      {
        myCar.accMag = 0;
        myCar.velMag = 0;
      }
    }
    else if(abs(myCar.velMag) >= 0.3)
    {
      myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*NATURAL_ACC;
    }
    else
    {
      myCar.accMag = 0;
      myCar.velMag = 0;
    }
    
    if(myCar.velMag > 0)
    {
      myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*BRAKE_ACC;
    }
  }
  else if(GEAR_MODE == Gear.N)
  {
    if(BRAKE_KEY)
    {
      if(abs(myCar.velMag) >= 0.3)
      {
        myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*BRAKE_ACC;
      }
      else
      {
        myCar.accMag = 0;
        myCar.velMag = 0;
      }
    }
    else if(abs(myCar.velMag) >= 0.3)
    {
      myCar.accMag = (abs(myCar.velMag)/myCar.velMag)*NATURAL_ACC;
    }
    else
    {
      myCar.accMag = 0;
      myCar.velMag = 0;
    }
  }
  
  if(STEER_LEFT && !STEER_RIGHT && CAR_DEL_ANGLE < 2.44)
  {
    CAR_DEL_ANGLE += 0.18;
  }
  if(STEER_RIGHT && !STEER_LEFT && CAR_DEL_ANGLE > -2.44)
  {
    CAR_DEL_ANGLE -= 0.18;
  }
  
  
  //println(mouseX, mouseY);
  myControls.angle = (CAR_DEL_ANGLE*-180)/2.5;
  myControls.brakePressed = BRAKE_KEY;
  myControls.accPressed = ACC_KEY;
  
  myCar.update();
  myCar.display();
  myControls.display();
}

class Car
{
  float posX;
  float posY;
  float angle;
  float velMag;
  float maxVel;
  float accMag;
  
  Car()
  {
    posX = 670;
    posY = 815;
    
    angle = 90;
    
    velMag = 0;
    maxVel = 15;
    
    accMag = 0;
  }
  
  void display()
  {
    push();
    translate(posX, posY);
    scale(0.025);
    rotate(radians(angle));
    fill(52, 70, 235);
    image(carImage, 0, 0);
    pop();
  }
  
  boolean boundaryDetection()
  {
    float angleTemp = angle;
    float velMagTemp = velMag;
    if(velMagTemp > 0)
    {
      angleTemp -= CAR_DEL_ANGLE * abs(velMagTemp);
    }
    else if(velMagTemp < 0)
    {
      angleTemp += CAR_DEL_ANGLE * abs(velMagTemp);
    }
    if((velMagTemp <= 0 && velMagTemp >= -maxVel) || (velMagTemp >= 0 && velMagTemp <= maxVel) || (velMagTemp < -maxVel && accMag > 0) || (velMagTemp > maxVel && accMag < 0))
    {
      velMagTemp += accMag;
    }
    velMagTemp = velMag + accMag;
    float velXTemp = velMagTemp*sin(radians(angleTemp));
    float velYTemp = velMagTemp*cos(radians(angleTemp));
    float posXTemp = posX + velXTemp;
    float posYTemp = posY - velYTemp;
    float cornerAngle = 25;
    float midAngle = 39;
    float midLength = 18;
    float halfDiag = 27;
    float halfAcross = 12;
    
    float posXcorner_1 = posXTemp + (halfDiag * sin(radians(angleTemp + cornerAngle)));
    float posYcorner_1 = posYTemp - (halfDiag * cos(radians(angleTemp + cornerAngle)));
    float posXcorner_2 = posXTemp + (halfDiag * sin(radians(angleTemp - cornerAngle)));
    float posYcorner_2 = posYTemp - (halfDiag * cos(radians(angleTemp - cornerAngle)));
    float posXcorner_3 = posXTemp + (halfDiag * sin(radians(angleTemp + cornerAngle - 180)));
    float posYcorner_3 = posYTemp - (halfDiag * cos(radians(angleTemp + cornerAngle - 180)));
    float posXcorner_4 = posXTemp + (halfDiag * sin(radians(angleTemp - cornerAngle - 180)));
    float posYcorner_4 = posYTemp - (halfDiag * cos(radians(angleTemp - cornerAngle - 180)));
    float posXcorner_5 = posXTemp + (halfDiag * sin(radians(angleTemp)));
    float posYcorner_5 = posYTemp - (halfDiag * cos(radians(angleTemp)));
    float posXcorner_6 = posXTemp + (halfDiag * sin(radians(angleTemp - 180)));
    float posYcorner_6 = posYTemp - (halfDiag * cos(radians(angleTemp - 180)));
    float posXcorner_7 = posXTemp + (halfAcross * sin(radians(angleTemp + 90)));
    float posYcorner_7 = posYTemp - (halfAcross * cos(radians(angleTemp + 90)));
    float posXcorner_8 = posXTemp + (halfAcross * sin(radians(angleTemp - 90)));
    float posYcorner_8 = posYTemp - (halfAcross * cos(radians(angleTemp - 90)));
    float posXcorner_9 = posXTemp + (midLength * sin(radians(angleTemp + midAngle)));
    float posYcorner_9 = posYTemp - (midLength * cos(radians(angleTemp + midAngle)));
    float posXcorner_10 = posXTemp + (midLength * sin(radians(angleTemp - midAngle)));
    float posYcorner_10 = posYTemp - (midLength * cos(radians(angleTemp - midAngle)));
    float posXcorner_11 = posXTemp + (midLength * sin(radians(angleTemp + midAngle - 180)));
    float posYcorner_11 = posYTemp - (midLength * cos(radians(angleTemp + midAngle - 180)));
    float posXcorner_12 = posXTemp + (midLength * sin(radians(angleTemp - midAngle - 180)));
    float posYcorner_12 = posYTemp - (midLength * cos(radians(angleTemp - midAngle - 180)));
    
    /*push();
    strokeWeight(5);
    point(posXcorner_1, posYcorner_1);
    point(posXcorner_2, posYcorner_2);
    point(posXcorner_3, posYcorner_3);
    point(posXcorner_4, posYcorner_4);
    point(posXcorner_5, posYcorner_5);
    point(posXcorner_6, posYcorner_6);
    point(posXcorner_7, posYcorner_7);
    point(posXcorner_8, posYcorner_8);
    point(posXcorner_9, posYcorner_9);
    point(posXcorner_10, posYcorner_10);
    point(posXcorner_11, posYcorner_11);
    point(posXcorner_12, posYcorner_12);
    pop();*/
    
    if(!outOfBoundsTest(posXcorner_1, posYcorner_1))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_2, posYcorner_2))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_3, posYcorner_3))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_4, posYcorner_4))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_5, posYcorner_5))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_6, posYcorner_6))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_7, posYcorner_7))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_8, posYcorner_8))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_9, posYcorner_9))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_10, posYcorner_10))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_11, posYcorner_11))
    {
      return false;
    }
    if(!outOfBoundsTest(posXcorner_12, posYcorner_12))
    {
      return false;
    }
    
    return true;
  }
  
  boolean outOfBoundsTest(float x,float y)
  {
    if(x >= width || x <= 0)
    {
      return false;
    }
    
    if(y >= height || y <= 0)
    {
      return false;
    }
    
    if(x <= 500 && y >= 678)
    {
      return false;
    }
    
    if(x <= 682 && y >= 678)
    {
      if(x <= 628 || y <= 787 || y >= 841)
      {
        return false;
      }
    }
    
    if(x >= 762 && y >= 820)
    {
      return false;
    }
    
    if(x >= 762 && y >= 378 && y <= 738)
    {
      if(x >= 810 || y <= 510 || y >= 572)
      {
        return false;
      }
    }
    
    if(x >= 197 && x <= 682 && y >= 378 && y <= 598)
    {
      if(y >= 487 || x <= 479 || x >= 523)
      {
        return false;
      }
    }
    
    if(x <= 116 && y >= 378)
    {
      if(x <= 107 || y <= 411 || y >= 462)
      {
        return false;
      }
    }
    
    if(x <= 341 && y <= 297)
    {
      return false;
    }
    
    if(x >= 424 && x <= 682 && y <= 297)
    {
      if(y >= 156)
      {
        if(x <= 599 || x >= 648 || y <= 270)
        {
          return false;
        }
      }
      else
      {
        if(x >= 577 || y <= 91)
        {
          return false;
        }
      }
    }
    
    if(x >= 764 && y <= 297)
    {
      return false;
    }
    
    if(x >= 692 && x <= 718 && y >= 867 && y <= 932)
    {
      return false;
    }
    if(x >= 730 && x <= 752 && y >= 618 && y <= 669)
    {
      return false;
    }
    if(x >= 858 && x <= 906 && y >= 747 && y <= 777)
    {
      return false;
    }
    if(x >= 525 && x <= 575 && y >= 608 && y <= 632)
    {
      return false;
    }
    if(x >= 390 && x <= 453 && y >= 645 && y <= 677)
    {
      return false;
    }
    if(x >= 692 && x <= 718 && y >= 417 && y <= 472)
    {
      return false;
    }
    if(x >= 798 && x <= 858 && y >= 308 && y <= 333)
    {
      return false;
    }
    if(x >= 160 && x <= 186 && y >= 564 && y <= 629)
    {
      return false;
    }
    if(x >= 422 && x <= 485 && y >= 342 && y <= 368)
    {
      return false;
    }
    if(x >= 276 && x <= 338 && y >= 309 && y <= 331)
    {
      return false;
    }
    if(x >= 352 && x <= 376 && y >= 220 && y <= 284)
    {
      return false;
    }
    if(x >= 391 && x <= 414 && y >= 63 && y <= 124)
    {
      return false;
    }
    if(x >= 23 && x <= 78 && y >= 307 && y <= 334)
    {
      return false;
    }
    if(x >= 725 && x <= 757 && y >= 100 && y <= 165)
    {
      return false;
    }
    
    return true;
  }
  
  void update()
  {
    if(!boundaryDetection())
    {
      velMag = 0;
      return;
    }
    if(velMag > 0)
    {
      angle -= CAR_DEL_ANGLE * abs(velMag);
    }
    else if(velMag < 0)
    {
      angle += CAR_DEL_ANGLE * abs(velMag);
    }
    if((velMag <= 0 && velMag >= -maxVel) || (velMag >= 0 && velMag <= maxVel) || (velMag < -maxVel && accMag > 0) || (velMag > maxVel && accMag < 0))
    {
      velMag += accMag;
    }
    float velX = velMag*sin(radians(angle));
    float velY = velMag*cos(radians(angle));
    posX += velX;
    posY -= velY;
  }
}

class Controls
{
  
  float angle;
  boolean brakePressed;
  boolean accPressed;
  float steeringScale;
  float pedalPressScale;
  
  Controls()
  {
    angle = 0;
    brakePressed = false;
    accPressed = false;
    steeringScale = 0.4;
    pedalPressScale = 0.85;
  }
  
  void display()
  {
    push();
    stroke(25);
    fill(25);
    rectMode(CENTER);
    rect(250, 810, 500, 260);
    pop();
    
    push();
    translate(120, height - 120);
    scale(steeringScale);
    rotate(radians(angle));
    image(steeringWheelImage, 0, 0);
    pop();
    
    push();
    translate(300, height - 120);
    scale(0.1);
    if(brakePressed)
    {
      scale(pedalPressScale);
    }
    image(brakeImage, 0, 0);
    pop();
    
    push();
    translate(375, height - 120);
    scale(0.1);
    if(accPressed)
    {
      scale(pedalPressScale);
    }
    image(acceleratorImage, 0, 0);
    pop();
    
    push();
    textSize(35);
    fill(0);
    if(GEAR_MODE == Gear.P)
    {
      fill(51, 133, 255);
    }
    rectMode(CENTER);
    rect(457, height - 213, 35, 35);
    fill(51, 133, 255);
    if(GEAR_MODE == Gear.P)
    {
      fill(0);
    }
    text("P", 445, height - 200);
    pop();
    
    push();
    textSize(35);
    fill(0);
    if(GEAR_MODE == Gear.R)
    {
      fill(51, 133, 255);
    }
    rectMode(CENTER);
    rect(457, height - 163, 35, 35);
    fill(51, 133, 255);
    if(GEAR_MODE == Gear.R)
    {
      fill(0);
    }
    text("R", 445, height - 150);
    pop();
    
    push();
    textSize(35);
    fill(0);
    if(GEAR_MODE == Gear.N)
    {
      fill(51, 133, 255);
    }
    rectMode(CENTER);
    rect(457, height - 113, 35, 35);
    fill(51, 133, 255);
    if(GEAR_MODE == Gear.N)
    {
      fill(0);
    }
    text("N", 445, height - 100);
    pop();
    
    push();
    textSize(35);
    fill(0);
    if(GEAR_MODE == Gear.D)
    {
      fill(51, 133, 255);
    }
    rectMode(CENTER);
    rect(457, height - 63, 35, 35);
    fill(51, 133, 255);
    if(GEAR_MODE == Gear.D)
    {
      fill(0);
    }
    text("D", 445, height - 50);
    pop();
  }
}

void keyPressed()
{
  if(keyCode == UP)
  {
    ACC_KEY = true;
  }
  else if(keyCode == DOWN)
  {
    BRAKE_KEY = true;
  }
  else if(keyCode == 's' || keyCode == 'S')
  {
    if(GEAR_MODE == Gear.P)
    {
      GEAR_MODE = Gear.R;
    }
    else if(GEAR_MODE == Gear.R)
    {
      GEAR_MODE = Gear.N;
    }
    else if(GEAR_MODE == Gear.N)
    {
      GEAR_MODE = Gear.D;
    }
  }
  else if(keyCode == 'w' || keyCode == 'W')
  {
    if(GEAR_MODE == Gear.R)
    {
      GEAR_MODE = Gear.P;
    }
    else if(GEAR_MODE == Gear.N)
    {
      GEAR_MODE = Gear.R;
    }
    else if(GEAR_MODE == Gear.D)
    {
      GEAR_MODE = Gear.N;
    }
  }
  else if(keyCode == 'a' || keyCode == 'A')
  {
    STEER_LEFT = true;
  }
  else if(keyCode == 'd' || keyCode == 'D')
  {
    STEER_RIGHT = true;
  }
}

void keyReleased()
{
  if(keyCode == UP)
  {
    ACC_KEY = false;
  }
  else if(keyCode == DOWN)
  {
    BRAKE_KEY = false;
  }
  else if(keyCode == 'a' || keyCode == 'A')
  {
    STEER_LEFT = false;
  }
  else if(keyCode == 'd' || keyCode == 'D')
  {
    STEER_RIGHT = false;
  }
}
