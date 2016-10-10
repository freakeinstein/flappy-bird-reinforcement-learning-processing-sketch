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
