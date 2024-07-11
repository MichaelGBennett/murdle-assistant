//ArrayList<mSquare> grid;
mSquare[][] grid;
ArrayList<mSquare> legendGrid;
ArrayList<mSquare> moves;
int textSize = 20;
int xOffset = 50;
int yOffset = 50;
int size = 30;

void setup(){
  moves = new ArrayList<mSquare>();
  int originalYOffset = yOffset;
  grid = new mSquare[12][12];
  //grid = new ArrayList<mSquare>();
  legendGrid = new ArrayList<mSquare>();
  
  char letter = 'A';
  for(int x = 0; x < 12; x++){
    int xPOS = x * size + xOffset;
    mSquare letterBox = new mSquare(x, 0, xPOS, 10, size);
    letterBox.setText("" + (char)(letter + x));
    letterBox.setBGColor(0xFFFFFF);
    legendGrid.add(letterBox);
  }
  
  String leftHandSideLetters = "MNOPIJKLEFGH";
  for(int y = 0; y < 12; y++){
    int yPOS = y * size + yOffset;
    mSquare letterBox = new mSquare(y, 0, 10, yPOS, size);
    letterBox.setText("" + leftHandSideLetters.charAt(y));
    letterBox.setBGColor(0xFFFFFF);
    legendGrid.add(letterBox);
  }
  
  for(int x = 0; x < 12; x++){
    int xPOS = x * size + xOffset;
    for (int y = 0; y < 4; y ++){
      int yPOS = y * size + yOffset;
      //grid.add(new mSquare(xPOS, yPOS, size));
      grid[x][y] = new mSquare(x, y, xPOS, yPOS, size);
      System.out.printf("x:%d y:%d\n", x, y);
    }
  }
  
  for(int x = 0; x < 8; x++){
    int xPOS = x * size + xOffset;
    for (int y = 4; y < 8; y ++){
      int yPOS = y * size + yOffset; 
      //grid.add(new mSquare(xPOS, yPOS, size));
      grid[x][y] = new mSquare(x, y, xPOS, yPOS, size);
    }
  }
  
  for(int x = 0; x < 4; x++){
    int xPOS = x * size + xOffset;
    for (int y = 8; y < 12; y ++){
      int yPOS = y * size + yOffset;
      //grid.add(new mSquare(xPOS, yPOS, size));
      grid[x][y] = new mSquare(x, y, xPOS, yPOS, size);
    }
  }
  
  yOffset = originalYOffset;
  
  textAlign(CENTER);
  textSize(textSize);
  size(500, 500);
}

void draw(){
  background(200);
  
  for (mSquare[] row : grid){
    for (mSquare square : row){
      if (square != null) square.drawMe();
    }
  }
  for (mSquare square : legendGrid){
    square.drawMe();
  }
  
  while (!moves.isEmpty()){
    mSquare move = moves.iterator().next();
    move.clickMe();
    if (move.getText().equals("o")){
      for (int i = 0; i < 12; i++){
        mSquare horizontalSquares = grid[i][move.getYIndex()];
        mSquare VerticalSquares = grid[move.getXIndex()][i];
        if (horizontalSquares != null && horizontalSquares.getXIndex() / 4 == move.getXIndex() / 4){
          if (!moves.contains(horizontalSquares)) moves.add(horizontalSquares);
        }
        if (VerticalSquares != null && VerticalSquares.getYIndex() / 4 == move.getYIndex() / 4){
          if (!moves.contains(VerticalSquares)) moves.add(VerticalSquares);
        }
      }
    }
    moves.remove(move);
  }
}

//TODO refactor code for a 2d array to clean up this math
void mouseClicked(){
  if (mouseButton == LEFT){
    //check if grit has been clicked
    for (mSquare[] row : grid){
      for (mSquare square : row){
        if (square != null && square.isClicked(mouseX, mouseY)){
          //MoveTuple move = new MoveTuple();
          //move.xPOS = mouseX;
          //move.yPOS = mouseY;
          
          moves.add(square);
        }
      }
    }
  }
  else if (mouseButton == RIGHT){
    
  }
}
