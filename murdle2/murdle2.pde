//ArrayList<mSquare> grid;
mSquare[][] grid;
mSquare[][] savedGrid;
ArrayList<mSquare> legendGrid;
ArrayList<mSquare> moves;
int textSize = 20;
int xOffset = 50;
int yOffset = 50;
int size = 30;
int murdleCategories = 4;
int murdleSuspectCount = 4;
int gridSize = (murdleCategories - 1) * murdleSuspectCount;

void setup(){
  moves = new ArrayList<mSquare>();
  grid = new mSquare[12][12];
  savedGrid = new mSquare[12][12];
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
  
  grid = newGrid(murdleCategories, murdleSuspectCount);
  
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
    processMoves();
  }
  else if (mouseButton == RIGHT){
    for (mSquare[] row : grid){
      for (mSquare square : row){
        if (square != null && square.isClicked(mouseX, mouseY)){
          square.setText("");
        }
      }
    }
  }
}

void keyPressed(){
  System.out.printf("Key %s pressed\n", key);
  if (key == 's'){
    for(int i = 0; i < 12; i++){
      for (int j = 0; j < 12; j++){
        if (savedGrid[i][j] != null && grid[i][j] != null)
        savedGrid[i][j].setText(grid[i][j].getText());
      }
    }
  }
  else if (key == 'l' || key == 'L'){
    for(int i = 0; i < 12; i++){
      for (int j = 0; j < 12; j++){
        if (savedGrid[i][j] != null && grid[i][j] != null)
        grid[i][j].setText(savedGrid[i][j].getText());
      }
    }
  }
  else if (keyCode == UP){
    murdleSuspectCount++;
    grid = newGrid(murdleCategories, murdleSuspectCount);
  }
  else if (keyCode == DOWN){
    murdleSuspectCount--;
    if (murdleSuspectCount <= 0) murdleSuspectCount = 1;
    grid = newGrid(murdleCategories, murdleSuspectCount);
  }
  else if (keyCode == RIGHT){
    murdleCategories -= 3;
    murdleCategories ++;
    murdleCategories %= 2;
    murdleCategories += 3;
    grid = newGrid(murdleCategories, murdleSuspectCount);
  }
}

void checkThreeXInBox(mSquare[][] grid, int leftX, int topY){
  for (int x = leftX; x < leftX + murdleSuspectCount; x++){
    int count = 0;
    mSquare blank = null;
    for (int y = topY; y < topY + murdleSuspectCount; y++){
      if (grid[x][y].getText().equals("x") && !moves.contains(grid[x][y])){
        count++;
      }
      else if (grid[x][y].getText().equals("")){
        blank = grid[x][y];
      }
    }
    if (count == murdleSuspectCount - 1 && blank != null){
      blank.setText("x");
      if (!moves.contains(blank)) moves.add(blank);
    }
  }
  
  for (int y = topY; y < topY + murdleSuspectCount; y++){
    int count = 0;
    mSquare blank = null;
    for (int x = leftX; x < leftX + murdleSuspectCount; x++){
      if (grid[x][y].getText().equals("x") && !moves.contains(grid[x][y])){
        count++;
      }
      else if (grid[x][y].getText().equals("")){
        blank = grid[x][y];
      }
    }
    if (count == murdleSuspectCount - 1 && blank != null){
      blank.setText("x");
      if (!moves.contains(blank)) moves.add(blank);
    }
  }
}

void checkThreeXInAllBoxes(){
  checkThreeXInBox(grid, 0, 0);
  checkThreeXInBox(grid, 0, murdleSuspectCount);
  checkThreeXInBox(grid, 0, murdleSuspectCount * 2);
  
  checkThreeXInBox(grid, murdleSuspectCount, 0);
  checkThreeXInBox(grid, murdleSuspectCount, murdleSuspectCount);
  
  checkThreeXInBox(grid, murdleSuspectCount * 2, 0);
}

mSquare[][] newGrid(int categories, int suspectCount){
  gridSize = (categories - 1) * suspectCount;
  mSquare[][] newGrid = new mSquare[gridSize][gridSize];
  
  if (categories == 3){
    for(int x = 0; x < suspectCount * 2; x++){
      int xPOS = x * size + xOffset;
      for (int y = 0; y < suspectCount; y ++){
        int yPOS = y * size + yOffset; 
        newGrid[x][y] = new mSquare(x, y, xPOS, yPOS, size);
      }
    }
    
    for(int x = 0; x < suspectCount; x++){
      int xPOS = x * size + xOffset;
      for (int y = suspectCount; y < suspectCount * 2; y ++){
        int yPOS = y * size + yOffset;
        newGrid[x][y] = new mSquare(x, y, xPOS, yPOS, size);
      }
    }
  }
  else if (categories == 4){
    for(int x = 0; x < suspectCount * 3; x++){
      int xPOS = x * size + xOffset;
      for (int y = 0; y < suspectCount; y ++){
        int yPOS = y * size + yOffset;
        newGrid[x][y] = new mSquare(x, y, xPOS, yPOS, size);
      }
    }
    
    for(int x = 0; x < suspectCount * 2; x++){
      int xPOS = x * size + xOffset;
      for (int y = suspectCount; y < suspectCount * 2; y ++){
        int yPOS = y * size + yOffset; 
        newGrid[x][y] = new mSquare(x, y, xPOS, yPOS, size);
      }
    }
    
    for(int x = 0; x < suspectCount; x++){
      int xPOS = x * size + xOffset;
      for (int y = suspectCount * 2; y < suspectCount * 3; y ++){
        int yPOS = y * size + yOffset;
        newGrid[x][y] = new mSquare(x, y, xPOS, yPOS, size);
      }
    }
  }
  else {
    System.err.println("invalid category number");
    return null;
  }
  return newGrid;
}

//void processMoves(){
//  while (!moves.isEmpty()){
//    mSquare move = moves.iterator().next(); //<>//
//    if (move == null){
//      moves.remove(move);
//      continue;
//    }
//    System.out.printf("processing move %d %d\n", move.getXIndex(), move.getYIndex());
//    move.clickMe();
//    if (move.getText().equals("o")){
//      for (int i = 0; i < gridSize; i++){
//        mSquare horizontalSquares = grid[i][move.getYIndex()];
//        mSquare VerticalSquares = grid[move.getXIndex()][i];
//        if (horizontalSquares != null){
//          if (horizontalSquares.getXIndex() / murdleSuspectCount == move.getXIndex() / murdleSuspectCount){
//            if (!moves.contains(horizontalSquares) && horizontalSquares.getText().equals("")){
//              moves.add(horizontalSquares);
//            }
//          }
//          else if (horizontalSquares.getText().equals("o") || horizontalSquares.getText().equals("x")){
//            if(horizontalSquares.getXIndex() >= murdleSuspectCount){
//              int yIndex = horizontalSquares.getXIndex() + murdleSuspectCount;
//              if (yIndex >= gridSize){
//                yIndex -= murdleSuspectCount * 2;
//              }
//              mSquare flippedSquare = grid[move.getXIndex()][yIndex];
//              if (flippedSquare != null){
//                if (!moves.contains(flippedSquare) && flippedSquare.getText().equals("")){
//                  if (horizontalSquares.getText().equals("o")) flippedSquare.setText("x");
//                  moves.add(flippedSquare);
//                }
//              }
//            }
//            if (move.getXIndex() >= murdleSuspectCount){
//              int yIndex = move.getXIndex() + murdleSuspectCount;
//              if (yIndex >= gridSize){
//                yIndex -= murdleSuspectCount * 2;
//              }
//              mSquare flippedSquare = grid[horizontalSquares.getXIndex()][yIndex];
//              if (flippedSquare != null){
//                if (!moves.contains(flippedSquare) && flippedSquare.getText().equals("")){
//                  if (horizontalSquares.getText().equals("o")) flippedSquare.setText("x");
//                  moves.add(flippedSquare);
//                }
//              }
//            }
//          }
//        }
//        if (VerticalSquares != null){
//          if (VerticalSquares.getYIndex() / murdleSuspectCount == move.getYIndex() / murdleSuspectCount){
//            if (!moves.contains(VerticalSquares) && VerticalSquares.getText().equals("")){
//              moves.add(VerticalSquares);
//            }
//          }
//          else if (VerticalSquares.getText().equals("o") || VerticalSquares.getText().equals("x")){
//            if (VerticalSquares.getYIndex() >= murdleSuspectCount){
//              int xIndex = VerticalSquares.getYIndex() + murdleSuspectCount;
//              if (xIndex >= gridSize){
//                xIndex -= murdleSuspectCount * 2;
//              }
//              mSquare flippedSquare = grid[xIndex][move.getYIndex()];
//              if (flippedSquare != null){
//                if (!moves.contains(flippedSquare) && flippedSquare.getText().equals("")){
//                  if (VerticalSquares.getText().equals("o")) flippedSquare.setText("x");
//                  moves.add(flippedSquare);
//                } //<>//
//              }
//            }
//            if (move.getYIndex() >= murdleSuspectCount){
//              int xIndex = move.getYIndex() + murdleSuspectCount;
//              if (xIndex >= gridSize){
//                xIndex -= murdleSuspectCount * 2;
//              }
//              mSquare flippedSquare = grid[xIndex][VerticalSquares.getYIndex()];
//              if (flippedSquare != null){
//                if (!moves.contains(flippedSquare) && flippedSquare.getText().equals("")){
//                  if (VerticalSquares.getText().equals("o")) flippedSquare.setText("x");
//                  moves.add(flippedSquare);
//                }
//              }
//            }
//          }
//        }
//      }
//    }
//    else if (move.getText().equals("x")){
//      for (int i = 0; i < gridSize; i++){
//        mSquare horizontalSquares = grid[i][move.getYIndex()];
//        mSquare VerticalSquares = grid[move.getXIndex()][i];
//        if (horizontalSquares != null){
//          if (!inSameBox(move, horizontalSquares)){
//            if (horizontalSquares.getText().equals("o")){
//              int yIndex = move.getXIndex();
//              if (murdleCategories == 4){
//                yIndex += murdleSuspectCount;
//                if (yIndex >= gridSize) yIndex -= murdleSuspectCount * 2;
//              }
//              mSquare flippedSquare = grid[horizontalSquares.getXIndex()][yIndex];
//              moves.add(flippedSquare);
//            }
//          }
//        }
//        if (VerticalSquares != null){
//          if (!inSameBox(move, VerticalSquares)){
//            if (VerticalSquares.getText().equals("o")){
//              int xIndex = move.getXIndex();
//              if (murdleCategories == 4){
//                xIndex += murdleSuspectCount;
//                if (xIndex >= gridSize) xIndex -= murdleSuspectCount * 2;
//              }
//              mSquare flippedSquare = grid[xIndex][VerticalSquares.getYIndex()];
//              moves.add(flippedSquare);
//            }
//          }
//        }
//      }
//    }
//    moves.remove(move);
//    checkThreeXInAllBoxes();
//  }
//}

void processMoves(){
  while (!moves.isEmpty()){
    mSquare move = moves.iterator().next(); //<>//
    moves.remove(move);
    if (move == null){
      continue;
    }
    move.clickMe();
    //move is an o
    if (move.getText().equals("o")){
      //add x in row and column of same box
      setCrossXfromO(move);
    }
    //move is an x
    if (move.getText().equals("x")){
    }
    checkThreeXInAllBoxes();
  }
}

boolean inSameBox(mSquare s1, mSquare s2){
  if (s1 == null) return false;
  if (s2 == null) return false;
  if (s1.getXIndex() / murdleSuspectCount == s2.getXIndex() / murdleSuspectCount &&
      s1.getYIndex() / murdleSuspectCount == s2.getYIndex() / murdleSuspectCount)
  {
    return true;
  }
  return false;
}

void setAboveOtoX(mSquare xSquare, mSquare up){
  if (up == null) return;
  if (!inSameBox(xSquare, up)) return;
  if (!moves.contains(up) && up.getText().equals("")){
    moves.add(up);
  }
  int yIndex = up.getYIndex();
  if (yIndex > 0) {
    setAboveOtoX(xSquare, grid[xSquare.getXIndex()][yIndex-1]);
  }
}

void setBelowOtoX(mSquare xSquare, mSquare down){
  if (down == null) return;
  if (!inSameBox(xSquare, down)) return;
  if (!moves.contains(down) && down.getText().equals("")){
    moves.add(down);
  }
  int yIndex = down.getYIndex();
  if (yIndex < gridSize - 1) {
    setBelowOtoX(xSquare, grid[xSquare.getXIndex()][down.getYIndex()+1]);
  }
}

void setLeftOtoX(mSquare xSquare, mSquare left){
  if (left == null) return;
  if (!inSameBox(xSquare, left)) return;
  if (!moves.contains(left) && left.getText().equals("")){
    moves.add(left);
  }
  int xIndex = left.getXIndex();
  if (xIndex > 0) {
    setLeftOtoX(xSquare, grid[xIndex -1][xSquare.getYIndex()]);
  }
}

void setRightOtoX(mSquare xSquare, mSquare right){
  if (right == null) return;
  if (!inSameBox(xSquare, right)) return;
  if (!moves.contains(right) && right.getText().equals("")){
    moves.add(right);
  }
  int xIndex = right.getXIndex();
  if (xIndex < gridSize - 1) {
    setRightOtoX(xSquare, grid[right.getXIndex() +1][xSquare.getYIndex()]);
  }
}

void setCrossXfromO(mSquare oSquare){
  int yIndex = oSquare.getYIndex(); //<>//
  int xIndex = oSquare.getXIndex();
  if (yIndex > 0) setAboveOtoX(oSquare, grid[xIndex][yIndex -1]);
  if (xIndex > 0) setLeftOtoX(oSquare, grid[xIndex -1][yIndex]);
  if (yIndex < gridSize -1) setBelowOtoX(oSquare, grid[xIndex][yIndex +1]);
  if (xIndex < gridSize -1) setRightOtoX(oSquare, grid[xIndex +1][yIndex]);
}
