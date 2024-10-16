//ArrayList<mSquare> grid;
mSquare[][] grid;
mSquare[][] savedGrid;
ArrayList<mSquare> legendGrid;
ArrayList<Move> moves;
int textSize = 20;
int xOffset = 50;
int yOffset = 50;
int size = 30;
int murdleCategories = 4;
int murdleSuspectCount = 4;
int gridSize = (murdleCategories - 1) * murdleSuspectCount;
mSquare selectedIconDisplay;
String selectedIcon = "x";

void setup(){
  moves = new ArrayList<Move>();
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
  
  selectedIconDisplay = new mSquare(1, 1, 10, 10, size);
  selectedIconDisplay.setText(selectedIcon);
  
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
  
  selectedIconDisplay.drawMe();
  selectedIconDisplay.setText(selectedIcon);
}

//TODO refactor code for a 2d array to clean up this math
void mouseClicked(){
  if (mouseButton == LEFT){
    //check if grit has been clicked
    for (mSquare[] row : grid){
      for (mSquare square : row){
        if (square != null && square.isClicked(mouseX, mouseY)){
          moves.add(new Move(square, selectedIcon));
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
  else if (key == 'x'){
    selectedIcon = "x";
  }
  else if (key == 'o'){
    selectedIcon = "o";
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
      if (grid[x][y].getText().equals("x") && !hasMove(moves, grid[x][y])){
        count++;
      }
      else if (grid[x][y].getText().equals("")){
        blank = grid[x][y];
      }
    }
    if (count == murdleSuspectCount - 1 && blank != null){
      if (!hasMove(moves, blank)) moves.add(new Move(blank, "o"));
    }
  }
  
  for (int y = topY; y < topY + murdleSuspectCount; y++){
    int count = 0;
    mSquare blank = null;
    for (int x = leftX; x < leftX + murdleSuspectCount; x++){
      if (grid[x][y].getText().equals("x") && !hasMove(moves, grid[x][y])){
        count++;
      }
      else if (grid[x][y].getText().equals("")){
        blank = grid[x][y];
      }
    }
    if (count == murdleSuspectCount - 1 && blank != null){
      if (!hasMove(moves, blank)) moves.add(new Move(blank, "o"));
    }
  }
}

void checkThreeXInAllBoxes(){
  if(murdleCategories == 4){
    checkThreeXInBox(grid, 0, 0);
    checkThreeXInBox(grid, 0, murdleSuspectCount);
    checkThreeXInBox(grid, 0, murdleSuspectCount * 2);
    
    checkThreeXInBox(grid, murdleSuspectCount, 0);
    checkThreeXInBox(grid, murdleSuspectCount, murdleSuspectCount);
    
    checkThreeXInBox(grid, murdleSuspectCount * 2, 0);
  }
  else {
    checkThreeXInBox(grid, 0, 0);
    checkThreeXInBox(grid, 0, murdleSuspectCount);
    checkThreeXInBox(grid, murdleSuspectCount, 0);
  }
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

void processMoves(){
  while (!moves.isEmpty()){
    Move move = moves.iterator().next();
    moves.remove(move);
    if (move == null || move.getMove() == null){
      continue;
    }
    mSquare target = move.getMove();
    String selectedText = move.getMoveText();
    target.setText(selectedText);
    
    //move is an o
    if (target.getText().equals("o")){
      //add x in row and column of same box
      setCrossXfromO(target);
      //mirror symbols in other boxes across the O diagonal
      for (int i = 4; i < gridSize; i++){
        mSquare horizontalSquare = grid[i][target.getYIndex()];
        if (horizontalSquare != null && !inSameBox(target, horizontalSquare) && !horizontalSquare.getText().equals("")){
          int yIndex = horizontalSquare.getXIndex();
          int xIndex = target.getXIndex();
          if (murdleCategories == 4){
            yIndex += murdleSuspectCount;
            if (yIndex >= gridSize) yIndex -= murdleSuspectCount * 2;
          }
          addFlippedSquareToMoves(grid[xIndex][yIndex], horizontalSquare.getText());
        }
        mSquare VerticalSquare = grid[target.getXIndex()][i];
        if (VerticalSquare != null && !inSameBox(target, VerticalSquare) && !VerticalSquare.getText().equals("")){
          int xIndex = VerticalSquare.getYIndex();
          int yIndex = target.getYIndex();
          if (murdleCategories == 4){
            xIndex += murdleSuspectCount;
            if (xIndex >= gridSize) xIndex -= murdleSuspectCount * 2;
          }
          addFlippedSquareToMoves(grid[xIndex][yIndex], VerticalSquare.getText());
        }
      }
      //look for o pairs
      int tx = target.getXIndex();
      int ty = target.getYIndex();
      int fx = ty;
      int fy = tx;
      if (murdleCategories == 4){
        fx = getFlippedIndex(ty);
        fy = getFlippedIndex(tx);
        for (int i = 0; i < gridSize; i++){
          mSquare flipped = grid[i][fy];
          mSquare cross = grid[i][ty];
          if (tx / murdleSuspectCount > i / murdleSuspectCount && ty / murdleSuspectCount < fy / murdleSuspectCount){
            addCrossedSquaresToMove(flipped, cross);
          }
          flipped = grid[fx][i];
          cross = grid[tx][i];
          if (ty / murdleSuspectCount > i / murdleSuspectCount && tx / murdleSuspectCount < fx / murdleSuspectCount)
          addCrossedSquaresToMove(flipped, cross);
        }
      }
      else {//3 categories
        for (int i = 0; i < murdleSuspectCount; i++){
          mSquare flipped = grid[i][fy];
          mSquare cross = grid[i][ty];
          addCrossedSquaresToMove(flipped, cross);
          flipped = grid[fx][i];
          cross = grid[tx][i];
          addCrossedSquaresToMove(flipped, cross);
        }
      }
    }
    //move is in an o row or col
    for (int i = 0; i < gridSize; i++){
      mSquare horizontalSquare = grid[i][target.getYIndex()];
      if (horizontalSquare != null && target.getXIndex() >= 4 && !inSameBox(target, horizontalSquare) && horizontalSquare.getText().equals("o")){
        int xIndex = horizontalSquare.getXIndex();
        int yIndex = target.getXIndex();
        if (murdleCategories == 4){
          yIndex += murdleSuspectCount;
          if (yIndex >= gridSize) yIndex -= murdleSuspectCount * 2;
        }
        addFlippedSquareToMoves(grid[xIndex][yIndex], selectedText);
      }
      mSquare VerticalSquare = grid[target.getXIndex()][i];
      if (VerticalSquare != null && target.getYIndex() >= 4 && !inSameBox(target, VerticalSquare) && VerticalSquare.getText().equals("o")){
        int yIndex = VerticalSquare.getYIndex();
        int xIndex = target.getYIndex();
        if (murdleCategories == 4){
          xIndex += murdleSuspectCount;
          if (xIndex >= gridSize) xIndex -= murdleSuspectCount * 2;
        }
        addFlippedSquareToMoves(grid[xIndex][yIndex], selectedText);
      }
    }
    checkThreeXInAllBoxes();
  }
}

void addFlippedSquareToMoves(mSquare f, String t){
  if (f != null && !hasMove(moves, f) && f.getText().equals("")){
    moves.add(new Move(f, t));
  }
}

void addCrossedSquaresToMove(mSquare flipped, mSquare cross){
  if (flipped != null && cross != null && !hasMove(moves, cross) && flipped.getText().equals("o") && cross.getText().equals("")){
    moves.add(new Move(cross, "o"));
  }
}

int getFlippedIndex(int index){
  int flipped = index + murdleSuspectCount;
  if (flipped >= gridSize) flipped -= murdleSuspectCount * 2;
  return flipped;
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
  if (!hasMove(moves, up) && up.getText().equals("")){
    moves.add(new Move(up, "x"));
  }
  int yIndex = up.getYIndex();
  if (yIndex > 0) {
    setAboveOtoX(xSquare, grid[xSquare.getXIndex()][yIndex-1]);
  }
}

void setBelowOtoX(mSquare xSquare, mSquare down){
  if (down == null) return;
  if (!inSameBox(xSquare, down)) return;
  if (!hasMove(moves, down) && down.getText().equals("")){
    moves.add(new Move(down, "x"));
  }
  int yIndex = down.getYIndex();
  if (yIndex < gridSize - 1) {
    setBelowOtoX(xSquare, grid[xSquare.getXIndex()][down.getYIndex()+1]);
  }
}

void setLeftOtoX(mSquare xSquare, mSquare left){
  if (left == null) return;
  if (!inSameBox(xSquare, left)) return;
  if (!hasMove(moves, left) && left.getText().equals("")){
    moves.add(new Move(left, "x"));
  }
  int xIndex = left.getXIndex();
  if (xIndex > 0) {
    setLeftOtoX(xSquare, grid[xIndex -1][xSquare.getYIndex()]);
  }
}

void setRightOtoX(mSquare xSquare, mSquare right){
  if (right == null) return;
  if (!inSameBox(xSquare, right)) return;
  if (!hasMove(moves, right) && right.getText().equals("")){
    moves.add(new Move(right, "x"));
  }
  int xIndex = right.getXIndex();
  if (xIndex < gridSize - 1) {
    setRightOtoX(xSquare, grid[right.getXIndex() +1][xSquare.getYIndex()]);
  }
}

void setCrossXfromO(mSquare oSquare){
  int yIndex = oSquare.getYIndex();
  int xIndex = oSquare.getXIndex();
  if (yIndex > 0) setAboveOtoX(oSquare, grid[xIndex][yIndex -1]);
  if (xIndex > 0) setLeftOtoX(oSquare, grid[xIndex -1][yIndex]);
  if (yIndex < gridSize -1) setBelowOtoX(oSquare, grid[xIndex][yIndex +1]);
  if (xIndex < gridSize -1) setRightOtoX(oSquare, grid[xIndex +1][yIndex]);
}

boolean hasMove(ArrayList<Move> moves, mSquare move){
  for (Move m: moves){
    if (move == m.getMove()) return true;
  }
  return false;
}
