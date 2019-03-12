

// draw state flags
boolean draw;
boolean start;
//boolean stop;


class DrawList {
    
  ArrayList<DrawPoint> l = new ArrayList();
  
  float drawWeight; 
  color drawColor;
  float travelWeight;
  color travelColor;  
  
  DrawList(float _drawWeight, color _drawColor) {
    drawWeight = _drawWeight;
    drawColor = _drawColor;
    travelWeight = drawWeight/2;
    travelColor = color(red(drawColor), green(drawColor), blue(drawColor), 50);
  }
    
  DrawList(float _drawWeight, color _drawColor, float _travelWeight, color _travelColor) {
    drawWeight = _drawWeight;
    drawColor = _drawColor;
    travelWeight = _travelWeight;
    travelColor = _travelColor;
  }
    
  void render() {    
    for(int i=0; i<l.size()-1; i++) {
      DrawPoint p1 = l.get(i);
      DrawPoint p2 = l.get(i+1);
      if(p2.draw && !p1.endpoint) {
        strokeWeight(drawWeight/zoom);
        stroke(drawColor);
      } else {
        strokeWeight(travelWeight/zoom);
        stroke(travelColor);
      }
      beginShape();
      vertex(p1.pos.x, p1.pos.y);
      vertex(p2.pos.x, p2.pos.y);
      endShape();
    }
  }
    
}

class DrawPoint {
  
  PVector pos;
  boolean draw;
  boolean startpoint;  // ie: beginShape()
  boolean endpoint;    // ie: endShape()
  
  DrawPoint(PVector _pos, boolean _draw, boolean _startpoint, boolean _endpoint) {
    pos = _pos;
    draw = _draw;
    startpoint = _startpoint;
    endpoint = _endpoint;
    checkBounds();
  }
    
  DrawPoint(PVector _pos, boolean _draw) { // if there is no endpoint/startpoint criteria, make it neither
    pos = _pos;
    draw = _draw;
    startpoint = false;
    endpoint = false;
    checkBounds();
  } 
  
  DrawPoint(PVector _pos) { // if there is no draw state criteria, make it a travel movement 
    pos = _pos;
    draw = false;
    startpoint = false;
    endpoint = false;
    checkBounds();
  }
  
  void checkBounds() {
    if(!disableClipping) {
      pos.x = pos.x < minX ? minX : pos.x;
      pos.x = pos.x > maxX ? maxX : pos.x;
      pos.y = pos.y < minY ? minY : pos.y;
      pos.y = pos.y > maxY ? maxY : pos.y;
    }
  }
 
}


void beginPlot() {
 start = true;
 draw = true;
}

void endPlot() {
 //stop = true;
 draw = false;
 if(drawList.l.size() > 0) { // to catch misplaced use of endPlot()
   DrawPoint p = drawList.l.get(drawList.l.size()-1);
   p.endpoint = true;
   drawList.l.set(drawList.l.size()-1,p);
 }
}

void plotDot(float x, float y) {
  PVector p = new PVector(x,y);
  drawList.l.add(new DrawPoint(p, true, true, true));  
}

void plotVertex(float x, float y) {
  PVector p = new PVector(x,y);
  drawList.l.add(new DrawPoint(p, draw, start, false));
  start = false;
  //stop = false;
}


void getCommands() {
  DrawPoint p = drawList.l.get(0);
  drawList.l.remove(0);
  traceList.l.add(p);
  
  if(p.draw) {
    if(p.startpoint) {
      commandList.add("G00 X" + p.pos.x + " Y" + p.pos.y + " F" + feedrateTravel);
      commandList.add(WAIT);
      commandList.add(START);
      commandList.add("G04 P"+ startDelay);
    } else {
      commandList.add("G01 X" + p.pos.x + " Y" + p.pos.y + " F" + feedrateDraw);
      commandList.add(WAIT);
    }
    if(p.endpoint) {
      commandList.add(WAIT);
      commandList.add(STOP);
      commandList.add("G04 P"+ stopDelay);
    }
  } else { 
    commandList.add("G00 X" + p.pos.x + " Y" + p.pos.y + " F" + feedrateTravel);
  } 
  
}


void startupCommands() { // sent once the 'start' response is received from the machine

  commandList.add("M203 X" + maxFeedrate + " Y" + maxFeedrate);
  commandList.add("M201 X" + maxAcceleration + " Y" + maxAcceleration);
  commandList.add("M204 S" + acceleration);
  commandList.add("M503");
  
}
    
void renderCurrentLine() {
  
  if(drawList.l.size()>0 && traceList.l.size()>0) {

      DrawPoint p1 = drawList.l.get(0);
      DrawPoint p2 = traceList.l.get(traceList.l.size()-1);
      if(p2.draw && !p2.endpoint) {
        stroke(currentLineColor);
        strokeWeight(currentLineWeight/zoom);
      } else {
        stroke(currentLineTravelColor);
        strokeWeight(currentLineTravelWeight/zoom);
      }
      beginShape();
      vertex(p1.pos.x, p1.pos.y);
      vertex(p2.pos.x, p2.pos.y);
      endShape();
      
  }
 
}
 