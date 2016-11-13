  // this set of code implements the Q learn algorithm for flappy bird.

  boolean show_log = false;

  // special variables for QLearn
  float x_dist = 200;
  float y_dist = 200;
  float normalize_width = width * 2;
  float normalize_height = height * 2;

  float reward = 2;
  float score_reward = 50;
  boolean score_reward_now = false;
  int punishment = -1000;
  int fly_energy = -100;
  int no_fly_energy = 1;
  float bias = 0.2;

  boolean proposedAction = false;

  float leraningRateValue = 0.8;
  float explorationRateValue = 0.05;
  float discountRateValue  = 0.9;
  int ageValue = 1;

  

  boolean reset_episode = true; // to check whether our bird is in dead state or in alive state

  double[][] input_state = new double[1][2];
  LA la = new LA();
  Vector input_vector;
  Vector old_input_vector;
  Vector Qvalue;
  Vector current_prediction;
  Vector old_prediction;
  int batch_counter_for_nn = 0;


  void DoQLearningStep(){
    reward += 0.001;
    
    input_state[0][0] = x_dist/normalize_width;
    input_state[0][1] = y_dist/normalize_height;
    input_vector = la.arrayToVector(input_state);
    old_input_vector = input_vector;

    current_prediction = mlp.feedForward(input_vector);
    old_prediction = mlp.feedForward(old_input_vector);
    Qvalue = old_prediction;

    if(!reset_episode){
      float rew = reward;
      if(score_reward_now) { rew += score_reward; score_reward_now = false; }
      train(rew);
    }else{
      train(punishment);
      reset_episode = false;
    }
    
    proposedAction = proposeAction();
    if(proposedAction){ ch= 'L';/* print("jump \n");*/ }
    else { /*print("fall \n");*/ }
    
  }

  void train(float reinforcement){
    double Qvalue_t = max_future(current_prediction) * discountRateValue;
    if(proposedAction){
      Qvalue_t += (fly_energy + reinforcement);
    }else{
      Qvalue_t += (no_fly_energy + reinforcement);
    }
    Qvalue_t *= leraningRateValue;
    if(proposedAction){
      Qvalue.set(0,0, ((1 - leraningRateValue)*old_prediction.get(0,0)+Qvalue_t) );
    }else{
      Qvalue.set(0,1, ((1 - leraningRateValue)*old_prediction.get(0,1)+Qvalue_t) );
    }
    mlp.backPropogate(old_prediction,Qvalue);

    if(batch_counter_for_nn % 50 == 0){
      mlp.updateGradients(); // update weights based on previous online learning.
      mlp.clearGradientsToZero(); // clear gradient accumulation after weights updation. IMPORTANT.
    }
    batch_counter_for_nn ++;
  }

  double max_future(Vector P){
    if(P.get(0,0) > P.get(0,1)) return P.get(0,0);
    else return P.get(0,1);
  }

  boolean proposeAction(){
    if(current_prediction.get(0,0) > current_prediction.get(0,1)) return true;
    else return false;
  }

  void giveScoreIncrementReward(){ // called from stumper
    score_reward_now = true;
  }
    