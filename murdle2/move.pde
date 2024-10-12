class Move {
  mSquare square;
  String newText;
  
  Move(mSquare square, String text){
    this.square = square;
    this.newText = text;
  }
  
  mSquare getMove(){
    return this.square;
  }
  
  String getMoveText(){
    return this.newText;
  }
}
