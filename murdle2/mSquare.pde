class mSquare{
 
  int xPOS;
  int yPOS;
  int size;
  String text = "";
  color bgColor = #FFFFFF;
  
  mSquare(int xPOS, int yPOS, int size){
    this.xPOS = xPOS;
    this.yPOS = yPOS;
    this.size = size;
    
  }
  
  boolean isClicked(int x, int y){
    if (x > xPOS && x < xPOS + size){
      if (y > yPOS && y < yPOS + size){
        return true;
      }
    }
    return false;
  }
  
  void drawMe(){
    fill(bgColor);
    rect(xPOS, yPOS, size, size);
    fill(0);
    text(text, xPOS, yPOS, size, size);
  }
  
  void clickMe(){
    if (text.equals("")){
      text = "x";
    }
    else if (text.equals("x")){
      text = "o";
    }
    else if (text.equals("o")){
      text = "";
    }
  }
  
  void setText(String text){
    this.text = text;
  }
  
  void setBGColor(color c){
    this.bgColor = c;
  }
  
  int getXPOS(){
    return xPOS;
  }
  
  int getYPOS(){
    return yPOS;
  }
  
  String getText(){
    return text;
  }
}
