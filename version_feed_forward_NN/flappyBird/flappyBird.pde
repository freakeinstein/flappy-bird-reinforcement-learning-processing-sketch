import ddf.minim.*;
import processing.serial.*;
Serial port;
Minim minim;
AudioSample wingSound,hitSound,scoreSound,dieSound;
boolean sound_enable = false;

int WIDTHSETUP = 1000;
int HEIGHTSETUP = 700;

ArrayList<Stump> stumps;

float stumpMIN=0,stumpMAX=0,stumpDiffY=150,stumpDiffX=250;
int stumpCount=0;
int birdX,score=0,nextStump=0,i,TopScore;
PImage[] imgNumBig,imgNumSmall;

Boolean hit=false,hitSnd=false,stumpHit=false,gameOver=false;
PVector birdPosition,velocity,gravity,up;
PImage[] bird;
PImage background,base,stump,stumpi;
int brd=0,deg=0,baseInc=0;
float BY,BGY;


int scene=0;
PImage imgTitle,imgGetReady;
PImage imageGameOver,imageScoreCard,imageClick,goldScoreCard;
int gameOverPosY,scoreCardPosY;

char ch= 'z';

MLP mlp = new MLP(3,2,15,2);

void setup(){
  size(1000,700);
  
  mlp.learningRate = 0.001;
  mlp.clearGradientsToZero();
  
// port = new Serial(this,Serial.list()[1],9600);

  frameRate(100000000);
  
  topScoreFileLoader();
  minim = new Minim(this);
  wingSound = minim.loadSample("wing.mp3",512);
  hitSound = minim.loadSample("hit.mp3",512);
  scoreSound  = minim.loadSample("point.mp3",512);
  dieSound = minim.loadSample("die.mp3",512);
  imgNumBig = new PImage[10];
  imgNumSmall = new PImage[10];
    for(i=0;i<10;i++){
      imgNumBig[i]=loadImage(i+".png");
      imgNumSmall[i]=loadImage(i+".png");
      imgNumSmall[i].resize(13,18);
    }
  

  bird = new PImage[3];
  bird[0]=loadImage("bird1.png");
  bird[1]=loadImage("bird2.png");
  bird[2]=loadImage("bird3.png");

  
  base=loadImage("base.png");
  stump=loadImage("stump.png");
  stumpi=loadImage("stumpi.png");
  
  stumps = new ArrayList<Stump>();
  stumpCount = (int) (width/(stumpDiffX+stump.width));
  stumpCount++;
  stumps.add(new Stump(random(stumpMIN,stumpMAX),0));
  for(int k=1;k<=stumpCount;k++){
    stumps.add(new Stump(/*random(stumpMIN,stumpMAX)*/200,stumpDiffX*k));
  }  
      imgTitle=loadImage("title.png");
    imgGetReady=loadImage("getReady.png");
    imageGameOver=loadImage("gameOver.png");
    imageScoreCard=loadImage("scoreCard.png");
    imageClick=loadImage("click.png");
    goldScoreCard=loadImage("goldScoreCard.png");
    
 initORreset();


    

  
}
void draw(){
  
 /*   ch=port.lastChar();
  *   if(ch=='L'){ lc=1;}
  *   if(ch=='R'){ lc=0;}
  */
 if(ch=='R'||ch=='L')//if(lc==1)
 {
    switch(scene)
  {
    case 0:    //title screen
      scene=1;
      break;
    case 1:   //get ready
      scene=2;
      break;
    case 2:   //game
      if(!stumpHit)
      {
        velocity.add(up);
        if(sound_enable) wingSound.trigger();
      }
      break;
    case 3:   //game over
      initORreset();
      scene=1;
      break;
  }
  ch = 'z';
 }
 
  drawBackground();
  textSize(35);
  fill(255,100);
  textAlign(CENTER);
  text("Hello Arduino, Hello Processing.", width/2, 40); 
  
  tracker(birdPosition.x,birdPosition.y); ////////////// ========================= TRACKER LIES HERE ! =========================================================
  switch(scene)
  {
    case 0:
    case 1:
             image(base,baseInc,BY);
             if(scene==0)
             {
               image(imgTitle,width/2 - imgTitle.width/2,height/4);
               image(bird[brd/10],width/2 - bird[0].width/2,height/2 + sin(radians(deg)*10)*5 -50);
             }
             else
             {
               image(imgGetReady,width/2 - imgGetReady.width/2,height/4);
               image(bird[brd/10],width/4,height/2 + sin(radians(deg)*10)*5 -50);
               image(imageClick,width/2 - imageClick.width/2,height/3 +50);
             }
             
             brd+=1;
              deg+=1;
           if(brd>20) brd=0;
           if(deg>360) deg=0;
            break;
    
    case 2:
      for(int k=0;k<stumps.size();k++){
        Stump st = stumps.get(k);
        st.checkHit();
        if(!stumpHit && !hit)
        {
          st.checkPassed();
          checkScored();
          st.update();
        }
        else
        {
          gameOver=true;
        }
        st.display();
      }
      
      
      image(base,baseInc,BY);
      flyingBird();
      /*stroke(0);
      line(0,stumpMIN,width,stumpMIN);
      stroke(#ffffff);
      line(0,stumpMAX,width,stumpMAX);*/
      if(hitSnd){if(sound_enable)hitSound.trigger(); fill(255); for(int z=0;z<100;z++) rect(0,0,width,height); hitSnd=false; if(stumpHit){ if(sound_enable) dieSound.trigger();}}
      printNum(score,width/2,height/6,'b');
      break;
    case 3:
        for(int k=0;k<stumps.size();k++){
          Stump st1 = stumps.get(k);
          st1.display();
        }
        image(base,baseInc,BY);
        translate(birdPosition.x,birdPosition.y);
        rotate(radians(90));
        image(bird[0],-bird[0].width/2,-bird[0].height/2);
        resetMatrix();
        if(gameOverPosY<height/6) gameOverPosY+=5;
        if(scoreCardPosY>height/6 +100) scoreCardPosY-=10;
        image(imageGameOver,width/2 - imageGameOver.width/2,gameOverPosY);
        if(score>TopScore)
        image(goldScoreCard,width/2 - goldScoreCard.width/2,scoreCardPosY);
        else
        image(imageScoreCard,width/2 - imageScoreCard.width/2,scoreCardPosY);
        //print Topscore
        printNum(score>TopScore?score:TopScore,width/2 + 90,scoreCardPosY+75,'s');
        
        //print score
        printNum(score,width/2 + 90,scoreCardPosY+35,'s');

        
        break;
  }
  
}
void mousePressed(){
  
  show_log = !show_log;
  
    switch(scene)
  {
    case 0:    //title screen
      scene=1;
      break;
    case 1:   //get ready
      scene=2;
      break;
    case 2:   //game
      if(!stumpHit)
      {
        velocity.add(up);
        if(sound_enable) wingSound.trigger();
      }
      break;
    case 3:   //game over
      initORreset();
      scene=1;
      break;
  }
}

void initORreset()
{
  if(score>TopScore)
  {
    TopScore=score;
    topScoreFileUpdator();
  }
  hit=false;hitSnd=false;stumpHit=false;gameOver=false;
  score=0;nextStump=0;
  birdX=width/4;
  birdPosition = new PVector(birdX,height/2 -50);
  velocity = new PVector(0,0);
  gravity = new PVector(0,.3);
  up = new PVector(0,-8);
    if((int)random(2)<1){
    background=loadImage("dayCity.png");
  }
  else{
    background=loadImage("nightCity.png"); 
  }
    BGY=-1*(background.height-height+base.height);
  BY=height-base.height;
  
  //================================================= Randomize stump ===========================
  stumpMIN = BY/6;
  stumpMAX = BY-stumpDiffY-stumpMIN;
      gameOverPosY=imageGameOver.height*-1;
    scoreCardPosY=height;
  
 // print(stumps.size());
  for(int k=0;k<stumps.size();k++){
        Stump st2 = stumps.get(k);
        st2.posY=random(stumpMIN,stumpMAX);
        st2.posX=stumpDiffX*k+width;
  }  
}
