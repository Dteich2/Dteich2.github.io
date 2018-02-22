String[] lines, labels;
float[] values;
Table table;
int rows, cols, dataRows, dataCols;

float[][] array;
float[] colMaxes, colMins, numInterval;

boolean[] colSelected, flipped, lineSelected;
int selectionTaken = -1;
boolean anyLineSelected;

lineInfo[] allLines;
  
void setup() { 
  
  String[][] table = new String[100][100];
  
  String[] rawData = loadStrings("C:/Users/Danny/Downloads/data.csv");
  for (int i = 0; i < 84; i++) {
    
    
    table[i] = splitTokens(rawData[i], ",");
    
  }
  
  
  
  size(1500, 1000);
  background(200);
  textAlign(CENTER, CENTER);
  surface.setResizable(true); 
  //table = loadTable("C:/Users/Danny/Documents/crimerateSmaller.csv", "csv");
  //table = loadTable("C:/Users/Danny/Downloads/data.csv", "csv");
  textSize(16);
  
 
  startP = new Point();
  endP = new Point();
  rows = 84;
  cols = 10;
  dataCols = cols - 1;
  dataRows = rows-1;
  println(dataCols);
  
  anyLineSelected = false;
  colSelected = new boolean[dataCols];
  flipped = new boolean[dataCols];
  
  rectangle = createGraphics(width, height);
  
  allLines = new lineInfo[dataRows];

  colMaxes = new float[dataCols];
  colMins = new float[dataCols];
  labels = new String[dataCols];
  for (int i = 0; i < dataCols; i++) {
    colMaxes[i] = -9999; 
    colMins[i] = 9999;  
  }
  
  array = new float[dataRows][dataCols];
  
  for(int j = 0; j < dataCols; j++) {
    labels[j] = table[0][j+1];
  }
  
  for(int i = 0; i < dataRows; i++) { 
    allLines[i] = new lineInfo();
    allLines[i].xLabel = table[i+1][0];
    allLines[i].xPoints = new float[dataCols];
    allLines[i].yPoints = new float[dataCols];
    allLines[i].featureLabels = new String[dataCols];
    float[] vals = new float[dataCols];
    allLines[i].vals = vals;
    allLines[i].lineVal = i;
    for(int j = 0; j < dataCols; j++) {
      //println(i + " " + j);
      allLines[i].vals[j] = Float.parseFloat(table[i+1][j+1]);
      array[i][j] = Float.parseFloat(table[i+1][j+1]);
      if (array[i][j] > colMaxes[j]) {
        colMaxes[j] = array[i][j];    
      }
      if (array[i][j] < colMins[j]) {
        colMins[j] = array[i][j];    
      }
    }
  }
  numInterval = new float[dataCols];
  for(int i = 0; i < dataCols; i++) {
    numInterval[i] = 0.8*height / (colMaxes[i] - colMins[i]);
  }
  for(int i = 0; i < dataRows; i++) {
    for(int j = 0; j < dataCols; j++) {
      allLines[i].xPoints[j] = (j+0.5) * (width/dataCols);
      allLines[i].yPoints[j] = 0.9*height-(array[i][j] - colMins[j]) * numInterval[j];
      
    }
  }
  
  //println(array[4][4]);
}

void draw() {
  
  background(200);
  for(int i = 0; i < dataCols; i++) {
    numInterval[i] = 0.8*height / (colMaxes[i] - colMins[i]);
  }
  for(int i = 0; i < dataRows; i++) {
    for(int j = 0; j < dataCols; j++) {
      allLines[i].xPoints[j] = (j+0.5) * (width/dataCols);
      if (flipped[j]) {
        allLines[i].yPoints[j] = 0.1*height+(array[i][j] - colMins[j]) * numInterval[j];
      }
      else {
        allLines[i].yPoints[j] = 0.9*height-(array[i][j] - colMins[j]) * numInterval[j];
      }
      
    }
  }
  selectionTaken = -1;
  for(int i = 0; i < dataRows; i++) {
    if(allLines[i].selected) {
      selectionTaken = i;  
    }
  }
  if (selectionTaken == -1) {
    anyLineSelected = false;  
  }
  else {
    anyLineSelected = true; 
  }
  fill(100);
  rect(startP.x, startP.y, endP.x-startP.x, endP.y-startP.y);
  fill(0);
  float[][] arrayXPos = new float[dataRows][dataCols];
  float[][] arrayYPos = new float[dataRows][dataCols];
  //numInterval = new float[dataCols];
  for(int i = 0; i < dataCols; i++) {
    //numInterval[i] = 0.8*height / (colMaxes[i] - colMins[i]);
    fill(100);
    stroke(0);
    rect(allLines[0].xPoints[i] - (width/(dataCols))/2, 0, (width/(dataCols)), 0.06*height);
    fill(0);
    text(labels[i], allLines[0].xPoints[i]-(width*0.5/(dataCols)), 0, (width/(dataCols)), 0.05*height);
    if (flipped[i]) {
      text(colMins[i]+" (min)", allLines[0].xPoints[i]-0.5*width/dataCols, height*0.05, (width/(dataCols)), height*0.05);
      text(colMaxes[i]+" (max)", allLines[0].xPoints[i]-0.5*width/dataCols, height*0.9, (width/(dataCols)), height*0.05);
    }
    else {
      text(colMaxes[i]+" (max)", allLines[0].xPoints[i]-0.5*width/dataCols, height*0.05, (width/(dataCols)), height*0.05);
      text(colMins[i]+" (min)", allLines[0].xPoints[i]-0.5*width/dataCols, height*0.9, (width/(dataCols)), height*0.05);
    }
    fill(150);
    rect(allLines[0].xPoints[i] - (width/(dataCols))/2, 0.94*height, (width/(dataCols)), 0.06*height);
    fill(0);
    text("flip", allLines[0].xPoints[i]-(width*0.5/(dataCols)), 0.95*height, (width/(dataCols)), 0.05*height);
  }
  
  for(int i = 0; i < dataRows; i++) {
    for(int j = 0; j < dataCols; j++) {
      allLines[i].featureLabels[j] = labels[j];
      allLines[i].vals[j] = array[i][j];
      ellipse(allLines[i].xPoints[j], allLines[i].yPoints[j], 2, 2); 
      //allLines[i].xPoints[j] = 50+ j * (0.9*width/(dataCols-1));
      //allLines[i].yPoints[j] =0.1*height+(array[i][j] - colMins[j]) * numInterval[j];
      arrayXPos[i][j] = allLines[i].xPoints[j];
      arrayYPos[i][j] = allLines[i].yPoints[j];
      //ellipse(50 + j * (0.9*width/(dataCols-1)), 0.9*height-(allLines[i].xPoints[j] - colMins[j]) * numInterval[j], 6, 6); 
      
    }
  }
  for(int i = 0; i < dataRows; i++) {
    for(int j = 0; j < dataCols-1; j++) {
      stroke(allLines[i].lineColor);
      if (colSelected[j]) {
        stroke(#009900);    
      }
      line(allLines[i].xPoints[j], allLines[i].yPoints[j], allLines[i].xPoints[j+1], allLines[i].yPoints[j+1]);
      //fill(0);
    }
  }
  for(int i = 0; i < dataRows; i++) {
    allLines[i].setup();
    allLines[i].draw();  
  }
}

void switchCols(int a, int b) {
  for(int i = 0; i < dataRows; i++) {
    float tmp = array[i][a];
    array[i][a] = array[i][b];
    array[i][b] = tmp;
  }
  float tmpMax = colMaxes[a];
  colMaxes[a] = colMaxes[b];
  colMaxes[b] = tmpMax;
  float tmpMin = colMins[a];
  colMins[a] = colMins[b];
  colMins[b] = tmpMin;
  String tmpLabel = labels[a];
  labels[a] = labels[b];
  labels[b] = tmpLabel;
}

//void mousePressed() {
//  //switchCols(3, 4);
//  fill(#00FF00);
//  float x = mouseX;
//  float y = mouseY;
//  if (mousePressed) {
//    rect(x, y, mouseX-x, mouseY-Y);
//  }
//  //flip(2);
//}

float a, b, c, d = 0;

class Point {
    public float x;
    public float y;
}

Point startP, endP;
PGraphics rectangle;

void mousePressed() {
  if (mouseY < 60) {
    int col = 0;
    for (int i = 0; i < dataCols; i++) {
      colSelected[i] = false;
    }
    for (int i = 0; i < dataCols-1; i++) {
      if (mouseX > (allLines[0].xPoints[i] + allLines[0].xPoints[i+1])/2) {
        col++;  
      }
    }
    //println(col);
    colSelected[col] = true;
    if (col > 0) {
      colSelected[col-1] = true;  
    }
  }
  else {
    int col = 0;
    for (int i = 0; i < dataCols; i++) {
      colSelected[i] = false;
    }
    if (mouseY > 0.95 * height) {
      for (int i = 0; i < dataCols-1; i++) {
        if (mouseX > (allLines[0].xPoints[i] + allLines[0].xPoints[i+1])/2) {
          col++;  
        }
      }
      flip(col);
      flipped[col] = !flipped[col];
    }
  }
  fill(100);
  startP.x = mouseX;
  startP.y = mouseY;
  endP.x = mouseX;
  endP.y = mouseY;
  rect(startP.x, startP.y, endP.x-startP.x, endP.y-startP.y);
}


void mouseDragged() {
  fill(100);
  endP.x = mouseX;
  endP.y = mouseY;
  //rect(startP.x, startP.y, endP.x-startP.x, endP.y-startP.y);
}

void mouseReleased() {
  //rectangle.endDraw(); 
  fill(100);
  rect(startP.x, startP.y, endP.x-startP.x, endP.y-startP.y);
}

void flip(int j) {
  for(int i = 0; i < dataRows; i++) {
    allLines[i].yPoints[j] = height-allLines[i].yPoints[j];
  }
  println("FLIPPED");
  draw();
}

class lineInfo {
  int lineVal;
  String xLabel;
  String[] featureLabels;
  float[] vals;
  float[] xPoints;
  float[] yPoints;
  color lineColor;
  String info;
  String status;
  boolean selected = false;
  void setup() {
    info = xLabel + '\n';
    lineColor = 0;
    for (int j = 0; j < dataCols; j++) {
      info += featureLabels[j] + ": " + vals[j] + '\n';
    }
  }
  void draw() {
    if (selected) {
      lineColor = #FF0000;  
      println("SELECTED");
    }
    //println(selectionTaken);
    for (int i = 0; i < xPoints.length-1; i++) {
      //println(selectionTaken);
      float slope = (yPoints[i+1] - yPoints[i]) / (xPoints[i+1] - xPoints[i]);
      float yInt = yPoints[i] - slope*xPoints[i];
      if (Math.abs((mouseX*slope+yInt-mouseY)) < 3 && mouseX < xPoints[i+1] && mouseX > xPoints[i] && (!anyLineSelected || selectionTaken == lineVal)) {
        lineColor = #FF0000;
        selected = true;
        selectionTaken = lineVal;
        anyLineSelected = true;
        
        fill(255);        
        textAlign(CENTER, CENTER);
        if (mouseX > width/2 && mouseY > height/2) {
          rect(mouseX - 250, mouseY-dataCols*30-30, 250, dataCols*30+30);
          fill(0);
          text(info, mouseX-250, mouseY-dataCols*30-30+5, 250, dataCols*30+30-10);
        }
        else if (mouseX <= width/2 && mouseY > height/2) {
          rect(mouseX, mouseY-dataCols*30-30, 250, dataCols*30+30-10);
          fill(0);
          text(info, mouseX+5, mouseY-dataCols*30-30+5, 250, dataCols*30+30-10);
        }
        else if (mouseX > width/2 && mouseY <= height/2) {
          rect(mouseX - 250, mouseY, 250, dataCols*30+30);
          fill(0);
          text(info, mouseX-250, mouseY+5, 250, dataCols*30+30-10);
        }
        else if (mouseX <= width/2 && mouseY <= height/2) {
          rect(mouseX, mouseY, 250, dataCols*30+30-5);
          fill(0);
          text(info, mouseX+5, mouseY+5, 250, dataCols*30+30-10);
        }
      }
      else {
        selected = false;  
        //selectionTaken = -1;
      }
      float aX = Math.min(startP.x, endP.x);
      float bX = Math.max(startP.x, endP.x);
      float aY = Math.min(startP.y, endP.y);
      float bY = Math.max(startP.y, endP.y);
      if(xPoints[i] > bX || xPoints[i+1] < aX || Math.max(yPoints[i], yPoints[i+1]) < aY || Math.min(yPoints[i], yPoints[i+1]) > bY) {
        status = "No Cross";  
      }
      else if (xPoints[i] < bX && xPoints[i+1] > aX) {
        status = "through";
        float slopeX = (yPoints[i+1] - yPoints[i]) / (xPoints[i+1] - xPoints[i]);
        float yIntX = yPoints[i] - slopeX * xPoints[i];
        if ((slopeX*aX+yIntX < aY && slopeX*bX+yIntX > aY) || (slopeX*aX+yIntX < bY && slopeX*bX+yIntX > bY) 
          || (slopeX*aX+yIntX > bY && slopeX*bX+yIntX < bY) || (slopeX*aX+yIntX > aY && slopeX*bX+yIntX < aY)
          || ((slopeX*aX+yIntX > aY && slopeX*aX+yIntX < bY) && (slopeX*bX+yIntX > aY && slopeX*bX+yIntX < bY))) {
           status = "inFromRight";
           if (selected) {
             lineColor = #FF0000;
           }
           else {
             lineColor = #FFFFFF;
           }
        }
      }
      
    }
  }
}

class segment {
  float xStart, xEnd, yStart, yEnd;
}