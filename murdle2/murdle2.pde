ArrayList<mSquare> grid;
ArrayList<mSquare> legendGrid;
int textSize = 20;
int xOffset = 50;
int yOffset = 50;
int size = 30;

void setup(){
  int originalYOffset = yOffset;
  
  grid = new ArrayList<mSquare>();
  legendGrid = new ArrayList<mSquare>();
  
  char letter = 'A';
  for(int x = 0; x < 12; x++){
    int xPOS = x * size + xOffset;
    mSquare letterBox = new mSquare(xPOS, 10, size);
    letterBox.setText("" + (char)(letter + x));
    letterBox.setBGColor(0xFFFFFF);
    legendGrid.add(letterBox);
  }
  
  String leftHandSideLetters = "MNOPIJKLEFGH";
  for(int y = 0; y < 12; y++){
    int yPOS = y * size + yOffset;
    mSquare letterBox = new mSquare(10, yPOS, size);
    letterBox.setText("" + leftHandSideLetters.charAt(y));
    letterBox.setBGColor(0xFFFFFF);
    legendGrid.add(letterBox);
  }
  
  for(int x = 0; x < 12; x++){
    int xPOS = x * size + xOffset;
    for (int y = 0; y < 4; y ++){
      int yPOS = y * size + yOffset;
      grid.add(new mSquare(xPOS, yPOS, size));
    }
  }
  
  yOffset += size * 4;
  for(int x = 0; x < 8; x++){
    int xPOS = x * size + xOffset;
    for (int y = 0; y < 4; y ++){
      int yPOS = y * size + yOffset; 
      grid.add(new mSquare(xPOS, yPOS, size));
    }
  }
  
  yOffset += size * 4;
  for(int x = 0; x < 4; x++){
    int xPOS = x * size + xOffset;
    for (int y = 0; y < 4; y ++){
      int yPOS = y * size + yOffset;
      grid.add(new mSquare(xPOS, yPOS, size));
    }
  }
  
  yOffset = originalYOffset;
  
  textAlign(CENTER);
  textSize(textSize);
  size(500, 500);
}

void draw(){
  background(200);
  
  for (mSquare square : grid){
    square.drawMe();
  }
  for (mSquare square : legendGrid){
    square.drawMe();
  }
  
}

//TODO refactor code for a 2d array to clean up this math
void mouseClicked(){
  if (mouseButton == LEFT){
    for (mSquare square : grid){
      if (square.isClicked(mouseX, mouseY)){
        square.clickMe();
        if (square.getText().equals("o")){
          for (mSquare xSquare : grid){
            if (square.getYPOS() == xSquare.getYPOS() || square.getXPOS() == xSquare.getXPOS()){
              if ((square.getXPOS() - xOffset) / size / 4 == (xSquare.getXPOS() - xOffset) / size / 4 && (square.getYPOS() - yOffset) / size / 4 == (xSquare.getYPOS() - yOffset) / size / 4){
                xSquare.setText("x");
              }
              // if clicked square = o and xsquare = x and is outside squares box but in squares row/col
              else if (xSquare.getText().equals("x")){
                for (mSquare mirrorSquare : grid){
                  int mirrordYPOS = (xSquare.getYPOS() - yOffset) / size;
                  int mirrordXPOS = (xSquare.getXPOS() - xOffset) / size;
                  
                  if (mirrordYPOS >= 4 && mirrordYPOS < 8) mirrordYPOS += 4;
                  else if (mirrordYPOS >= 8 && mirrordYPOS < 12) mirrordYPOS -= 4;
                  else if (mirrordYPOS >= 0 && mirrordYPOS < 4) mirrordYPOS -= 4;
                  
                  if (mirrordXPOS >= 4 && mirrordXPOS < 8) mirrordXPOS += 4;
                  else if (mirrordXPOS >= 8 && mirrordXPOS < 12) mirrordXPOS -= 4;
                  else if (mirrordXPOS >= 0 && mirrordXPOS < 4) mirrordXPOS -= 4;
                  
                  if (((mirrorSquare.getXPOS() - xOffset) / size == mirrordYPOS && (mirrorSquare.getYPOS() - yOffset) / size == (square.getYPOS() - yOffset) / size)
                    || (mirrorSquare.getYPOS() - yOffset) / size == mirrordXPOS && (mirrorSquare.getXPOS() - xOffset) / size == (square.getXPOS() - xOffset) / size){
                    mirrorSquare.setText("x");
                  }
                }
              }
            }
          }
          square.setText("o");
        }
      }
    } 
  }
  else if (mouseButton == RIGHT){
    for (mSquare square : grid){
      if (square.isClicked(mouseX, mouseY)){
        square.setText("");
      }
    }
  }
}
