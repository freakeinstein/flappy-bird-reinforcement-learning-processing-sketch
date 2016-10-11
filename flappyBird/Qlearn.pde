// this set of code implements the Q learn algorithm for flappy bird.

// special variables for QLearn
float x_dist = 200;
float y_dist = 200;

int reward = 1;
int punishment = 1000;

float leraningRateValue = 0.6;
float explorationRateValue = 1;
int ageValue = 1;

int xxxx = 0;

boolean reset_episode = true; // to check whether our bird is in dead state or in alive state

QMatrix flappyQMatrix = new QMatrix(WIDTHSETUP,HEIGHTSETUP,0);
Qelement current_state = flappyQMatrix.getState(x_dist,y_dist);
Qelement old_state = flappyQMatrix.getState(x_dist,y_dist);

void DoQLearningStep(){
  current_state = flappyQMatrix.getState(x_dist,y_dist);
  if(!reset_episode){
    updateQMatrix(reward,true,leraningRateValue, explorationRateValue, old_state, current_state );
  }else{
    updateQMatrix(punishment,false,leraningRateValue, explorationRateValue, old_state, current_state );
    reset_episode = false;
  }
  
  boolean proposedAction = proposeActionFromProbability(current_state,explorationRateValue,ageValue);
  if(proposedAction){ ch= 'L';/* print("jump \n");*/ }
  else { /*print("fall \n");*/ }
  
  
}

boolean proposeActionFromProbability(Qelement state, float explorationRate, int age){
  float probability = exp(explorationRate*age*state.jump_score)/(exp(explorationRate*age*state.jump_score)+exp(explorationRate*age*state.no_jump_score));
  //if(probability != 0.5)
  print(state.jump_score,state.no_jump_score,"probability",probability,"\n");
  float rand = random(0,1);
  if(rand < probability){
    return true;
  }else{
    return false;
  }
}

void updateQMatrix(int reinforcement, boolean is_reward, float learning_rate,float explorationRate, Qelement ostate, Qelement nstate ){
  
    print("before update ",ostate.jump_score,"\n");
    ostate.jump_score = (1-learning_rate)*ostate.jump_score + learning_rate*( reinforcement + explorationRate * nstate.max_future_score() );
  if(is_reward){
    
  }else{
    // do something
  }
  print("after update ",ostate.jump_score,"\n");
}
  