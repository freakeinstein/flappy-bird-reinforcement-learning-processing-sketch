class QMatrix{
  Qelement[][] QMatrix_;
  
  QMatrix(int w,int h, float val1, float val2){
    
    QMatrix_ = new Qelement [w][2*h];
    for (int i=0;i<w;i++){
      for (int j=0;j<(h*2);j++){
        QMatrix_[i][j] = new Qelement(val1,val2);
      }
    }
    //print(QMatrix_.length,QMatrix_[999].length);
  }
  
  Qelement getState(float w,float h){
    //print((int)w,"  ",(int)h,"\n");
    w = w/200;
    h = h/200;
    //print(w,h,"\n");
    return QMatrix_ [((int)w)][(2*height-((int)h))-1];
  }

}