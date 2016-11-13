class LA{
  
  Vector dot(Vector A, Vector B){
    int[] Alen = A.length();
    int[] Blen = B.length();
    Vector temp = new Vector(Alen[0],Blen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Blen[1];j++){
        double sum=0;
        for(int k=0;k<Alen[1];k++){
          sum = sum + A.get(i,k) * B.get(k,j);
        }
        temp.set(i,j,sum);
      }
    }
    
    return temp;
  }
  
  Vector times(Vector A, Vector B){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double result = A.get(i,j) * B.get(i,j);
        temp.set(i,j,result);
      }
    }
    
    return temp;
  }
  
  Vector sub(Vector A, Vector B){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double result = A.get(i,j) - B.get(i,j);
        temp.set(i,j,result);
      }
    }
    
    return temp;
  }
  
  Vector add(Vector A, Vector B){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double result = A.get(i,j) + B.get(i,j);
        temp.set(i,j,result);
      }
    }
    
    return temp;
  }
  
  
  Vector trans(Vector A){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[1],Alen[0]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        temp.set(j,i,A.get(i,j));
      }
    }
    
    return temp;
  } 
  
  
  Vector sigmoid(Vector A){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double sig = sigmoid(A.get(i,j));
        temp.set(i,j,sig);
      }
    }
    
    return temp;
  }
  
  Vector sigmoidGrad(Vector A){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double sig = sigmoid(A.get(i,j));
        double sigrad = sig*(1-sig);
        temp.set(i,j,sigrad);
      }
    }
    
    return temp;
  }
  
  double sigmoid(double x){
    return 1/(1+exp(-1*(float)x));
  }
  
  Vector logarithm(Vector A){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double log = log((float)A.get(i,j));
        temp.set(i,j,log);
      }
    }
    
    return temp;
  }
  
  Vector addScalar(Vector A, float scalar){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double sum = A.get(i,j)+scalar;
        temp.set(i,j,sum);
      }
    }
    
    return temp;
  }
  
  Vector multScalar(Vector A, float scalar){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double sum = A.get(i,j)*scalar;
        temp.set(i,j,sum);
      }
    }
    
    return temp;
  }
  
  Vector divScalar(Vector A, float scalar){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]);
    
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        double sum = A.get(i,j)/scalar;
        temp.set(i,j,sum);
      }
    }
    
    return temp;
  }
  
  Vector rowSum(Vector A){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],1);
    
    for(int i=0;i<Alen[0];i++){
      double sum = 0;
      for(int j=0;j<Alen[1];j++){
        sum += A.get(i,j);
      }
      temp.set(i,0,sum);
    }
    
    return temp;
  }
  
  Vector colSum(Vector A){
    int[] Alen = A.length();
    Vector temp = new Vector(1,Alen[1]);
    
    for(int i=0;i<Alen[1];i++){
      double sum = 0;
      for(int j=0;j<Alen[0];j++){
        sum += A.get(j,i);
      }
      temp.set(0,i,sum);
    }
    
    return temp;
  }
  
  
  Vector arrayToVector(double[] input){
    Vector temp = new Vector(input.length,1);
    for(int r=0;r<input.length;r++){
      temp.set(r,0,input[r]);
    }
    return temp;
  }
  
  Vector arrayToVector(double[][] input){
    Vector temp = new Vector(input.length,input[0].length);
    for(int r=0;r<input.length;r++){
      for (int c=0;c<input[0].length;c++){
        temp.set(r,c,input[r][c]);
      }
    }
    return temp;
  }
  
  Vector withBias(Vector A){
    int[] Alen = A.length();
    Vector temp = new Vector(Alen[0],Alen[1]+1);
    
    for(int i=0;i<Alen[0];i++){
      temp.set(i,0,1);
    }
    for(int i=0;i<Alen[0];i++){
      for(int j=0;j<Alen[1];j++){
        temp.set(i,j+1,A.get(i,j));
      }
    }
    
    return temp;
  }
  
  Vector subSample(Vector A,int r_top, int r_bottom, int c_left, int c_right){
    int[] ln = A.length();
    Vector temp = new Vector(ln[0] - (r_top + r_bottom),ln[1] - (c_left - c_right));
    for(int i=r_top;i<ln[0]-r_bottom;i++){
      for(int j=c_left;j<ln[1]-c_right;j++){
        temp.set(i-r_top,j-c_left,A.get(i,j));
      }
    }
    return temp;
  }
  
}