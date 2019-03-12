
// ellipse resolution
int resolution = 24;
//float arcInterval = 1;


void plotLine(float x1, float y1, float x2, float y2) {
  plotVertex(x1,y1);
  plotVertex(x2,y2);
}

void plotRect(float x, float y, float w, float h) {
  plotVertex(x,y);
  plotVertex(x+w,y);
  plotVertex(x+w,y+h);
  plotVertex(x,y+h);
  plotVertex(x,y);
}

void plotEllipse(float x, float y, float r1) {
  plotEllipse(x,y,r1,r1,resolution);
}

void plotEllipse(float x, float y, float r1, float r2) {
  plotEllipse(x,y,r1,r2,resolution);
}
  
void plotEllipse(float x, float y, float r1, float r2, float res) {
  for(float a = 0; a<TWO_PI; a+= TWO_PI/res) {
    plotVertex(x + r1*sin(a)/2, y + r2*cos(a)/2);
  }
  plotVertex(x + r1*sin(0)/2, y + r2*cos(0)/2);
}


// simple macros

void drawSquares(float x, float y, float w, float step) {
  while(w > 2) {
    beginPlot();
    plotRect(x-w/2,y-w/2,w,w);
    endPlot();
    w -= step;
  }
}

void drawCircles(float x, float y, float rad, float step) {
  while (rad > 2) {
    beginPlot();
    plotEllipse(x,y,rad,rad);
    endPlot(); 
    rad -= step;
  }
}

void spray(float x, float y) {
   float s = random(10,25);
   x = random(x-50, x+50);
   y = random(y-50, y+50);
   beginPlot();
   plotEllipse(x,y,s/2,s/2);
   //plotRect(x-s/2,y-s/2,s,s);
   endPlot();
}

/*
void bounce() {
 
 //random xy starting point and direction/force
 //once the pen is still, pick another point.
 

}*/

void applyTool(int tool, float x, float y) {
  switch(tool) {
   case(1):
     beginPlot();
     plotLine(toolX, toolY, x, y);
     endPlot();
     break;
   case(2):
     beginPlot();
     plotRect(toolX, toolY, x-toolX, y-toolY);
     endPlot();
     break;
   case(3):
     float r = dist(toolX, toolY, x, y);
     beginPlot();
     plotEllipse(toolX, toolY, r*2, r*2);
     endPlot();
     break;
   case(4):
     endPlot();
     break;
   case(5):
     break; 
   case(6):
     drawText(x,y, paintText);
     break;  
  }
  usingTool = false;
}

void previewTool(int tool, float x, float y) {
  if(!usingTool) {
    toolX = x;
    toolY = y;
    usingTool = true;
    paintText = cp5.get(Textfield.class,"textInput").getText();
    if(tool == 4) //orbit tool
      beginPlot();
  }
  stroke(toolLineColor);
  strokeWeight(toolLineWeight);
  switch(tool) {
    case(1): 
      line(toolX, toolY, x, y); 
      break;
    case(2): 
      rect(toolX, toolY, x-toolX, y-toolY);
      break;
    case(3): 
      float r = dist(toolX, toolY, x, y);
      ellipse(toolX, toolY, r*2, r*2);
      break;
    case(4):
      orbit(x,y);
      toolX = x;
      toolY = y;
      break;
    case(5):
      dots(x,y);
      toolX = x;
      toolY = y;
      break;    
    case(6):
      drawText(x,y, paintText, true);
      break;
  }
}

void orbit(float x, float y) {
  float d = dist(toolX, toolY, x, y) + 3; 
  toolA += TWO_PI/10;
  plotVertex(x + 30*sin(toolA)/2, y + 30*cos(toolA)/2);
}

void dots(float x, float y) {
  float d = dist(toolX, toolY, x, y) + 10; 
  plotDot(random(x-d, x+d), random(y-d, y+d));
}



void exportGcode() {
  
  String[] export = new String[0];
  
  for(int i=0; i<gcode.size(); i++) {
    String line = gcode.get(i);
    export = (String[])append(export, line);
  }
  String name = new String(
    "gcode-export_" + 
    nf(day(),2) + "-" + nf(month(),2) + "_" +
    nf(hour(),2) + "-" + nf(minute(),2) + "-" + nf(second(),2)
    );
  saveStrings(name, export);
  
}


void cleanTool() {

  cleanTool(pageWidth + 30,40,30,6);
  
}

void cleanTool(float padX, float padY, float padSize, int numSwipes) {
  
  disableClipping = true;
  
  for(int i=0; i<numSwipes; i++) {
    float x1 = padX + random(-padSize/2, padSize/2);
    float y1 = padY + random(-padSize, padSize);
    //beginPlot();
    plotVertex(x1, y1);
    //endPlot();
  }
  
  disableClipping = false;
  
}