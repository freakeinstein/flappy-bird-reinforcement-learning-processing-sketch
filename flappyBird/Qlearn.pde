// this set of code implements the Q learn algorithm for flappy bird.

// special variables for QLearn
float x_dist = 200;
float y_dist = 200;

int reward = 1;
int punishment = -20;
float bias = 0.2;

boolean proposedAction = false;

float leraningRateValue = 0.8;
float explorationRateValue = .1;
int ageValue = 1;

int xxxx = 0;

boolean reset_episode = true; // to check whether our bird is in dead state or in alive state

QMatrix flappyQMatrix = new QMatrix(WIDTHSETUP,HEIGHTSETUP,1,100);
Qelement current_state = flappyQMatrix.getState(x_dist,y_dist);
Qelement old_state = current_state;

void DoQLearningStep(){
  //print(old_state.jump_score,"\n");
  current_state = flappyQMatrix.getState(x_dist,y_dist);
  if(!reset_episode){
    updateQMatrix(reward,proposedAction,leraningRateValue, explorationRateValue, old_state, current_state );
  }else{
    updateQMatrix(punishment,proposedAction,leraningRateValue, explorationRateValue, old_state, current_state );
    reset_episode = false;
  }
  
  proposedAction = proposeActionFromProbability(current_state,explorationRateValue,ageValue);
  if(proposedAction){ ch= 'L';/* print("jump \n");*/ }
  else { /*print("fall \n");*/ }
  
  
  old_state = current_state;
  //print(old_state.jump_score," - ");
}

boolean proposeActionFromProbability(Qelement state, float explorationRate, int age){
  float probability = exp(explorationRate*age*state.jump_score)/(exp(explorationRate*age*state.jump_score)+exp(explorationRate*age*state.no_jump_score));
 // if(probability != 0.01798621)
  print(state.jump_score,state.no_jump_score,"probability",probability,"\n");
  float rand = random(0,1);
  if(rand < probability*bias){
    return true;
  }else{
    return false;
  }
}

void updateQMatrix(int reinforcement, boolean is_jump, float learning_rate,float explorationRate, Qelement ostate, Qelement nstate ){
  
    //print("before update ",ostate.jump_score,"\n");
    //ostate.jump_score = (1-learning_rate)*ostate.jump_score + learning_rate*( reinforcement + explorationRate * nstate.max_future_score() );
    //print(prr,"\n");
  if(is_jump){
    ostate.jump_score = (1-learning_rate)*ostate.jump_score + learning_rate*( reinforcement + explorationRate * nstate.max_future_score() );
  }else{
    ostate.no_jump_score = (1-learning_rate)*ostate.jump_score + learning_rate*( reinforcement + explorationRate * nstate.max_future_score() );
  }
  //print("after update ",ostate.jump_score,"\n");
}
  