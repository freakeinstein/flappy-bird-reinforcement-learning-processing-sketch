class Vector{
  int n_raw;
  int n_col;
  double [] array;
  Vector(int r, int c){
    n_raw = r;
    n_col = c;
    
    array = new double[(r*c)];
  }
  
  double get(int r, int c){
    
    return (array[ r * n_col + c ]);
  }
  
  void set(int r, int c, double val){
    array[ r * n_col + c ] = val;
  }
  
  void makeRandom(float start,float end){
    for(int r=0;r<n_raw;r++){
      for(int c=0;c<n_col;c++){
        array[ r * n_col + c ] = random(start,end);
      }
    }
  }
  
  void fill(double val){
    for(int r=0;r<n_raw;r++){
      for(int c=0;c<n_col;c++){
        array[ r * n_col + c ] = val;
      }
    }
  }
  
  int[] length(){
    int[] temp = new int[2];
    temp[0] = n_raw;
    temp[1] = n_col;
    
    return temp;
  }
  
  
}