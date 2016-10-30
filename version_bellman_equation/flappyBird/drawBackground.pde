void drawBackground(){
  image(background,0,BGY); 
  if(!hit)
  {
  baseInc-=2;
  if(baseInc<-24) baseInc=0;
  }
}
