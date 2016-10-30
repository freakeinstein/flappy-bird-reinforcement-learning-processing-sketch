package flappybird1;

import java.util.ArrayList;

//import ddf.minim.AudioSample;
//import ddf.minim.Minim;
import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;



public class MainClass extends PApplet {

	//Serial port;
	//Minim minim;
	//AudioSample wingSound,hitSound,scoreSound,dieSound;
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


	// stuffs for q learning begin
	// this set of code implements the Q learn algorithm for flappy bird.

	boolean show_log = false;

	// special variables for QLearn
	float x_dist = 200;
	float y_dist = 200;

	float reward = 2;
	float score_reward = 50;
	boolean score_reward_now = false;
	int punishment = -1000;
	int fly_energy = -100;
	int no_fly_energy = 1;
	float bias = (float) 0.2;

	boolean proposedAction = false;

	float leraningRateValue = (float) 0.8;
	float explorationRateValue = (float) 0.05;
	float discountRateValue  = (float) 0.9;
	int ageValue = 1;

	int xxxx = 0;

	boolean reset_episode = true; // to check whether our bird is in dead state or in alive state

	QMatrix flappyQMatrix = new QMatrix(WIDTHSETUP,HEIGHTSETUP,1,100);
	Qelement current_state = flappyQMatrix.getState(x_dist,y_dist,height);
	Qelement old_state = current_state;
	// stuffs for q learning end

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		PApplet.main("flappybird1.MainClass");
	}

	@Override
	public void draw() {
		// TODO Auto-generated method stub
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
					// if(sound_enable) wingSound.trigger();
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
			if(hitSnd){/*if(sound_enable)hitSound.trigger();*/ fill(255); for(int z=0;z<100;z++) rect(0,0,width,height); hitSnd=false; if(stumpHit){ /*if(sound_enable) dieSound.trigger();*/}}
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

	@Override
	public void settings() {
		// TODO Auto-generated method stub
		size(1000,700);
	}

	@Override
	public void setup() {
		// TODO Auto-generated method stub
		// port = new Serial(this,Serial.list()[1],9600);

		frameRate(100000000);

		topScoreFileLoader();
		// minim = new Minim(this);
		// wingSound = minim.loadSample("wing.mp3",512);
		// hitSound = minim.loadSample("hit.mp3",512);
		// scoreSound  = minim.loadSample("point.mp3",512);
		// dieSound = minim.loadSample("die.mp3",512);
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

	public void mousePressed(){

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
				//  if(sound_enable) wingSound.trigger();
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
		gravity = new PVector(0,(float) .3);
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

	void DoQLearningStep(){
		reward += 0.001;
		// if(show_log) print(old_state.jump_score,"\n");
		current_state = flappyQMatrix.getState(x_dist,y_dist,height);
		if(!reset_episode){
			float rew = reward;
			if(score_reward_now) { rew += score_reward; score_reward_now = false; }
			updateQMatrix(rew,proposedAction,leraningRateValue, discountRateValue, old_state, current_state );
		}else{
			updateQMatrix(punishment,proposedAction,leraningRateValue, discountRateValue, old_state, current_state );
			reset_episode = false;
		}

		proposedAction = proposeActionFromProbability(current_state,explorationRateValue,ageValue);
		if(proposedAction){ ch= 'L';/* print("jump \n");*/ }
		else { /*print("fall \n");*/ }


		old_state = current_state;
		//print(old_state.jump_score," - ");
	}

	boolean proposeActionFromProbability(Qelement state, float explorationRate, int age){
		//float probability = abs(explorationRate*age*state.jump_score)/(abs(explorationRate*age*state.jump_score)+abs(explorationRate*age*state.no_jump_score));
		// exp(explorationRate*age*state.jump_score)/(exp(explorationRate*age*state.jump_score)+exp(explorationRate*age*state.no_jump_score));
		//if(probability < 0.4 && show_log) 
		if(show_log) print(state.jump_score,state.no_jump_score,"\n");//"probability",probability,"\n");
		//float rand = random(0,1);
		if(state.jump_score > state.no_jump_score){ //rand < probability){//*bias){
			return true;
		}else{
			return false;
		}
	}

	void updateQMatrix(float reinforcement, boolean is_jump, float learning_rate,float discountRate, Qelement ostate, Qelement nstate ){

		//print("before update ",ostate.jump_score,"\n");
		//ostate.jump_score = (1-learning_rate)*ostate.jump_score + learning_rate*( reinforcement + explorationRate * nstate.max_future_score() );
		//print(prr,"\n");
		if(is_jump){
			ostate.jump_score = (1-learning_rate)*ostate.jump_score + learning_rate*( reinforcement + fly_energy + discountRate * nstate.max_future_score() );
		}else{
			ostate.no_jump_score = (1-learning_rate)*ostate.jump_score + learning_rate*( reinforcement + no_fly_energy + discountRate * nstate.max_future_score() );
		}
		//print("after update ",ostate.jump_score,"\n");
	}

	void giveScoreIncrementReward(){ // called from stumper
		score_reward_now = true;
	}

	void drawBackground(){
		image(background,0,BGY); 
		if(!hit)
		{
			baseInc-=2;
			if(baseInc<-24) baseInc=0;
		}
	}

	void flyingBird(){
		float posY=0;
		if(!hit){
			posY = sin(radians(deg)*10);brd+=1;}
		applyForces();
		translate(birdPosition.x,birdPosition.y+posY*5);
		if(gravity.y/12 != 0)
			rotate(velocity.y/12);
		else rotate(radians(90));
		image(bird[brd/10],-bird[brd/10].width/2,-bird[brd/10].height/2);
		resetMatrix();
		deg+=1;
		if(brd>20) brd=0;
		if(deg>360) deg=0;
		floorHit();
	}


	void applyForces(){
		velocity.add(gravity);
		velocity.limit(7);
		birdPosition.add(velocity);
	}

	void floorHit(){
		if((birdPosition.y > BY || birdPosition.y < 0) && (!hit || stumpHit)){
			birdPosition.sub(velocity);
			velocity.set(0,0);
			gravity.set(0,0);
			hit=true;
			if(!stumpHit)hitSnd=true;
			scene=3;
		}
	}

	void printNum(int n,int xPos,int Ypos, char bigOrSmall)
	{
		//xpos is not correct. score prints right align
		int t;
		if(n==0)
		{
			if(bigOrSmall=='s') 
			{
				xPos-=imgNumSmall[0].width;
				image(imgNumSmall[0],xPos,Ypos);
			} 
			else if(bigOrSmall=='b')
			{
				xPos-=imgNumBig[0].width;
				image(imgNumBig[0],xPos,Ypos);
			}
		}
		while(n>0)
		{
			t=n%10;
			if(bigOrSmall=='s') 
			{
				xPos-=imgNumSmall[t].width;
				image(imgNumSmall[t],xPos,Ypos);
			} 
			else if(bigOrSmall=='b')
			{
				xPos-=imgNumBig[t].width;
				image(imgNumBig[t],xPos,Ypos);
			}

			n=n/10;
		}
	}

	void topScoreFileLoader(){
		String lines[] = loadStrings("data.aff");
		TopScore=unhex(lines[2]);
	}
	void topScoreFileUpdator(){
		String words = "5df5745h5 @#SDG54541sfs "+hex(TopScore)+" YUGYU56%^$%tgrtYTFG% HJHDS45%$%$ 8674543423&&^(DSHFJU 7451#Dd";
		String[] list = split(words, ' ');

		// Writes the strings to a file, each on a separate line
		saveStrings("data.aff", list);
	}

	void stumper(float x,float y){
		image(stumpi,x,y-stumpi.height);
		image(stump,x,y+stumpDiffY);
	}

	void checkScored()
	{
		if(stumps.get(nextStump).posX+stump.width < birdX){
			score++;
			if(nextStump<4)nextStump++; else nextStump=0;
			//scoreSound.trigger();
			giveScoreIncrementReward();
		}
	}

	public class Stump {

		float posX=0,posY;
		Stump(float y,float x)
		{
			posY = y;
			posX = x+width;
		}
		void update(){
			posX-=1.86;
			//rect(posX-20,posY,stump.width,stumpDiffY);
		}
		void display(){
			stumper(posX,posY);
		}

		void checkPassed()
		{
			if( posX+stump.width < 0){
				posX = stumpDiffX+width;
				stumpCount++;
			}
		}
		void checkHit(){
			if(birdPosition.x>=(posX-15) && birdPosition.x <=(posX-15)+stump.width && !stumpHit)
			{
				if(birdPosition.y<posY || birdPosition.y>posY+stumpDiffY){
					hit=true;
					stumpHit=true;
					hitSnd=true;
				}
			}
		}
	}

	void tracker(float x, float y){
		boolean debug = false;

		// boolean last_reset = true; // to keep track of death penalty, kinda worst method but not interested to disturb original flappy bird code :(
		// boolean current_reset = true;
		//if(last_reset && !current_reset){ reset_episode = true; print("here 1"); }
		//else reset_episode = false;

		if(debug){
			fill(000000);
			ellipse(x,y,10,10);
		}

		// below step is to keep track of the birds relative position from nearest next stump
		x_dist = dist(stumps.get(nextStump).posX+stump.width,stumps.get(nextStump).posY,birdPosition.x,stumps.get(nextStump).posY);
		y_dist = dist(birdPosition.x,stumps.get(nextStump).posY,birdPosition.x,birdPosition.y);

		//print(dist(stumps.get(nextStump).posX+stump.width,stumps.get(nextStump).posY,x,stumps.get(nextStump).posY),"  ",dist(x,stumps.get(nextStump).posY,x,y),"\n");
		//stumps.get(nextStump).posX+stump.width;

		if(debug){
			stroke(000000);
			line(stumps.get(nextStump).posX+stump.width,stumps.get(nextStump).posY,x,stumps.get(nextStump).posY);
			line(x,stumps.get(nextStump).posY,x,y);
		}



		if(scene != 2){ // this is to skip intro scenes => useful during training.
			// last_reset = current_reset;
			//current_reset = true;
			reset_episode = true;
			ch = 'L';
		}else{
			//last_reset = current_reset;
			//current_reset = false;
			DoQLearningStep(); // if we're on game scene, do learning
		}
	}

}
