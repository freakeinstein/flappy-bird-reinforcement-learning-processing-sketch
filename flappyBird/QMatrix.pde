class QMatrix{
  Qelement[][] QMatrix_;
  
  QMatrix(int w,int h, float val){
    
    QMatrix_ = new Qelement [w][2*h];
    for (int i=0;i<w;i++){
      for (int j=0;j<h*2;j++){
        QMatrix_[i][j] = new Qelement(val,val);
      }
    }
  }
  
  Qelement getState(int w,int h){
    
    return QMatrix_ [w][2*height+h];
  }

}