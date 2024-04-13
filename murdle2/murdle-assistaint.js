grid = []
legendGrid = []
textSizeVar = 20;
xOffset = 50;
yOffset = 50;
size = 30;

function setup() {
  
  var originalYOffset = yOffset;
  
  var topLetters = "ABCDEFGHIJKL";
  for(var x = 0; x < 12; x++){
    var xPOS = x * size + xOffset;
    var letterBox = new mSquare(xPOS, 10, size);
    letterBox.setText("" + topLetters.charAt(x));
    letterBox.setBGColor(0xFFFFFF);
    legendGrid.push(letterBox);
  }
  
  var leftHandSideLetters = "MNOPIJKLEFGH";
  for(var y = 0; y < 12; y++){
    var yPOS = y * size + yOffset;
    var letterBox = new mSquare(10, yPOS, size);
    letterBox.setText("" + leftHandSideLetters.charAt(y));
    letterBox.setBGColor(0xFFFFFF);
    legendGrid.push(letterBox);
  }
  
  for(var x = 0; x < 12; x++){
    var xPOS = x * size + xOffset;
    for (var y = 0; y < 4; y ++){
      var yPOS = y * size + yOffset;
      grid.push(new mSquare(xPOS, yPOS, size));
    }
  }
  
  yOffset += size * 4;
  for(var x = 0; x < 8; x++){
    var xPOS = x * size + xOffset;
    for (var y = 0; y < 4; y ++){
      var yPOS = y * size + yOffset; 
      grid.push(new mSquare(xPOS, yPOS, size));
    }
  }
  
  yOffset += size * 4;
  for(var x = 0; x < 4; x++){
    var xPOS = x * size + xOffset;
    for (var y = 0; y < 4; y ++){
      var yPOS = y * size + yOffset;
      grid.push(new mSquare(xPOS, yPOS, size));
    }
  }
  
  yOffset = originalYOffset;
  
  textAlign(CENTER);
  textSize(textSizeVar);
  let canvas = createCanvas(500, 500);
  
  canvas.mouseClicked(clickInGrid);
}

function draw() {
  background(200);
  
  grid.forEach(x => x.drawMe())
  legendGrid.forEach(x => x.drawMe())
    
}

function clickInGrid() {
  if (mouseButton == LEFT){
      grid.forEach(clickedSquare => {
        if (clickedSquare.isClicked(mouseX, mouseY)){
          clickedSquare.clickMe();
          if (clickedSquare.getText() === "o"){
            grid.forEach(xSquare => {
            if (clickedSquare.getYPOS() == xSquare.getYPOS() || clickedSquare.getXPOS() == xSquare.getXPOS()){
              var csx = Math.floor((clickedSquare.getXPOS() - xOffset) / size / 4)
              var csy = Math.floor((clickedSquare.getYPOS() - yOffset) / size / 4)
              var xsx = Math.floor((xSquare.getXPOS() - xOffset) / size / 4)
              var xsy = Math.floor((xSquare.getYPOS() - yOffset) / size / 4)
              if (csx == xsx && csy == xsy){
                xSquare.setText("x");
              }
              // if clicked square = o and xsquare = x and is outside squares box but in squares row/col
              else if (xSquare.getText() === "x"){
                grid.forEach(mirrorSquare => {
                  var mirrordYPOS = (xSquare.getYPOS() - yOffset) / size;
                  var mirrordXPOS = (xSquare.getXPOS() - xOffset) / size;
                  
                  if (mirrordYPOS >= 4 && mirrordYPOS < 8) mirrordYPOS += 4;
                  else if (mirrordYPOS >= 8 && mirrordYPOS < 12) mirrordYPOS -= 4;
                  else if (mirrordYPOS >= 0 && mirrordYPOS < 4) mirrordYPOS -= 4;
                  
                  if (mirrordXPOS >= 4 && mirrordXPOS < 8) mirrordXPOS += 4;
                  else if (mirrordXPOS >= 8 && mirrordXPOS < 12) mirrordXPOS -= 4;
                  else if (mirrordXPOS >= 0 && mirrordXPOS < 4) mirrordXPOS -= 4;
                  
                  if (((mirrorSquare.getXPOS() - xOffset) / size == mirrordYPOS && (mirrorSquare.getYPOS() - yOffset) / size == (clickedSquare.getYPOS() - yOffset) / size) || (mirrorSquare.getYPOS() - yOffset) / size == mirrordXPOS && (mirrorSquare.getXPOS() - xOffset) / size == (clickedSquare.getXPOS() - xOffset) / size){
                    mirrorSquare.setText("x");
                  }
                })
              }
            }
          })
          clickedSquare.setText("o");
        }
      }
    })
  }
  else if (mouseButton == RIGHT){
    grid.forEach(clickedSquare => {
      if (square.isClicked(mouseX, mouseY)){
        square.setText("");
      }
    })
  }
}

class mSquare{
  
  constructor(xPOS, yPOS, size){
    this.xPOS = xPOS;
    this.yPOS = yPOS;
    this.size = size;
    this.boxtext = ""
    this.bgColor = color(255, 255, 255);
  }
  
  isClicked(x, y){
    if (x > this.xPOS && x < this.xPOS + this.size){
      if (y > this.yPOS && y < this.yPOS + this.size){
        return true;
      }
    }
    return false;
  }
  
  drawMe(){
    var c = this.bgColor == null ? color(255) : this.bgColor
    fill(c);
    rect(this.xPOS, this.yPOS, this.size, this.size);
    fill(0);
    text(this.boxtext, this.xPOS, this.yPOS, this.size, this.size);
  }
  
  clickMe(){
    if (this.boxtext === ""){
      this.boxtext = "x";
    }
    else if (this.boxtext === "x"){
      this.boxtext = "o";
    }
    else if (this.boxtext === "o"){
      this.boxtext = "";
    }
  }
  
  setText(boxtext){
    this.boxtext = boxtext;
  }
  
  setBGColor(c){
    if (c != null){
      this.bgColor = c;
    }
  }
  
  getXPOS(){
    return this.xPOS;
  }
  
  getYPOS(){
    return this.yPOS;
  }
  
  getText(){
    return this.boxtext;
  }
}