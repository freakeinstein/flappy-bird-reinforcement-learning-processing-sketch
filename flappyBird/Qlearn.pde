// this set of code implements the Q learn algorithm for flappy bird.

boolean show_log = false;

// special variables for QLearn
float x_dist = 200;
float y_dist = 200;

float reward = 2;
int punishment = -1000;
int fly_energy = -50;
int no_fly_energy = 1;
float bias = 0.2;

boolean proposedAction = false;

float leraningRateValue = 0.8;
float explorationRateValue = 0.05;
float discountRateValue  = 0.9;
int ageValue = 1;

int xxxx = 0;

boolean reset_episode = true; // to check whether our bird is in dead state or in alive state

QMatrix flappyQMatrix = new QMatrix(WIDTHSETUP,HEIGHTSETUP,1,100);
Qelement current_state = flappyQMatrix.getState(x_dist,y_dist);
Qelement old_state = current_state;

void DoQLearningStep(){
  reward += 0.001;
 // if(show_log) print(old_state.jump_score,"\n");
  current_state = flappyQMatrix.getState(x_dist,y_dist);
  if(!reset_episode){
    updateQMatrix(reward,proposedAction,leraningRateValue, discountRateValue, old_state, current_state );
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
  float probability = abs(explorationRate*age*state.jump_score)/(abs(explorationRate*age*state.jump_score)+abs(explorationRate*age*state.no_jump_score));
  // exp(explorationRate*age*state.jump_score)/(exp(explorationRate*age*state.jump_score)+exp(explorationRate*age*state.no_jump_score));
  if(probability < 0.4 && show_log) print(state.jump_score,state.no_jump_score,"probability",probability,"\n");
  float rand = random(0,1);
  if(rand < probability){//*bias){
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
  