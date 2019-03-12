
import processing.serial.*;

import java.util.*;
import javax.swing.JOptionPane;
import java.awt.FileDialog;

import controlP5.*;

// ======== SERIAL ========= //

Serial port;  // Create object from Serial class
String serialPort;
boolean serialConnected;
int gotResponse = 1; // starts 'ready'
                     // counts up as 'ok' messages are received
                     // counts down as commands are sent
                     // allows for ansynchronous processing of commands
                     // when gotResponse = 0, it means we are waiting for the machine, and no new commands will be sent


// ========= MACHINE TALK ======== //

DrawList drawList;  // planned activity as DrawPoint objects. once sent as commands, these get sent to traceList
DrawList traceList; // history of activity as DrawPoint objects
ArrayList<String>  commandList = new ArrayList();    // buffer of Gcode commands to send to the robot
ArrayList<String>  gcode = new ArrayList();          // history of Gcode commands sent. can be exported as a gcode file to reproduce the activity.

String START = "M107"; // "M280 P0 S70"; // Drop Pen
String STOP = "M106";  // "M280 P0 S70"; // Lift Pen
String HOME = "G28";
String WAIT = "M400";  // "finish all moves" - waits for response sent by marlin once machine has finished moving 

// Plotter settings
int feedrateDraw;
int feedrateTravel;
int startDelay; // delay to wait for pen to drop before drawing line [millis]
int stopDelay;  // delay before lifting pen at end of line
int acceleration;
int maxAcceleration;
int maxFeedrate;

boolean monitorGcode = false;


// ======== PAGE SETUP ========= //

float scale;    // pixels per mm
int pageWidth;  // size of sheet in mm
int pageHeight;
boolean disableClipping;
float minX, maxX, minY, maxY;

// ======== GUI ========= //


ControlP5 cp5;

color backgroundColor = color(150);
color pageColor = color(255);
int   viewportMargin = 20; 
int cpWidth = 300;

color currentLineColor =       color(255,0,0);
color currentLineTravelColor = color(255,0,0,150);
color drawLineColor =          color(0,255,255);
color drawLineTravelColor =    color(0,255,255,150);
color traceLineColor =         color(0,0,255);
color traceLineTravelColor =   color(0,0,255,150);
color toolLineColor =          color(255,0,255);

float currentLineWeight = 1.5;
float drawLineWeight = 1;
float traceLineWeight = 1;
float currentLineTravelWeight = 0.05;
float drawLineTravelWeight = 0.05;
float traceLineTravelWeight = 0.05;
float toolLineWeight = 1;

float panX = 0;
float panY = 0;
float zoom = 1;//5;
float zoomX;
float zoomY;

// ======== TOOLS ======== //

boolean paintMode = false;
boolean paused;
boolean clearPaths;
int paintTool;
boolean usingTool = false;
float toolX;
float toolY;
float toolA; // used in orbit()
PShape shape;
PShape child;
boolean placeShape = false;
boolean parseShape = false;
int childIndex; 
int vertexIndex; 
float textSize = 10;
String paintText = "";
boolean playGame = false;

// ========== TEMP

// temp fix for drawing arraylist slowness
boolean updateDisplay = true;

// hack to move origin, not sure if makes sense or not.
float translateX;
float translateY;
boolean invertY = true;  // true puts the origin in bottom left corner


void settings() {
  loadPreferences();
  size(int(pageWidth*scale + viewportMargin*2 + cpWidth), int(pageHeight*scale + viewportMargin*2)); 
}

void setup() {

  //open serial port select dialog
  if (serialPort == null) {
    serialPort = (String) JOptionPane.showInputDialog(
      null, 
      "Which Port?", 
      "Select Port", 
      JOptionPane.PLAIN_MESSAGE, 
      null, 
      Serial.list(), 
      Serial.list()[Serial.list().length-1]
    );
    
    println(serialPort);
    
    // List all the available serial ports 
    try {
      port = new Serial(this, serialPort, 115200);
      port.bufferUntil('\n');
      serialConnected = true;
    }
    catch(Exception e) {
      serialConnected = false;
      //exit();
    }
  }
  
  println("Page Width = "+pageWidth+" mm");
  println("Page Height = "+pageHeight+" mm");
  minX = 0;
  minY = 0;
  maxX = pageWidth;
  maxY = pageHeight;
  if(invertY)
    translateY = pageHeight;  // puts the origin in bottom left corner

  background(backgroundColor);
  noFill();
  //smooth();

  cp5 = new ControlP5(this);
  initGUI();
  panX = cpWidth;
  //cf = addControlFrame("plotterTalk control panel", 300,600);  

  drawList = new DrawList(drawLineWeight, drawLineColor, drawLineTravelWeight, drawLineTravelColor);
  traceList = new DrawList(traceLineWeight, traceLineColor, traceLineTravelWeight, traceLineTravelColor);
  
}


void draw() {

  if (mousePressed  && !paintMode) {
    zoomX = mouseX;
    zoomY = mouseY;
    if (mouseButton == LEFT) {
      panX += (mouseX - pmouseX);
      panY += (mouseY - pmouseY);
    } else {
      zoom +=  (mouseY - pmouseY)*0.01;
    }
  }
  
  // uncommented but display still not persistent, not sure why.
  background(backgroundColor);
 
  if(clearPaths) {
    drawList.l.clear();
    traceList.l.clear(); 
    clearPaths = false;
    playGame = false; 
  }
  
  pushMatrix();
  scale(scale, scale); 
  translate(translateX, translateY);
  translate(viewportMargin, viewportMargin);
  translate(panX, panY);  
  scale(zoom);
  
  if(invertY)
    scale(1,-1);  // flip y axis to put origin in bottom left corner
    
  fill(pageColor);
  noStroke();
  rect(0, 0, pageWidth, pageHeight);
  noFill();
  
  if(mousePressed && paintMode) {
    
    float x = transformMouseX();
    float y = transformMouseY();
    
    if(paintTool == 0) {
      plotVertex(x,y);
    } else {
      previewTool(paintTool, x, y);
    }
    
  } 
  
  if(placeShape) {
    float x = transformMouseX();
    float y = transformMouseY();
    shape(shape, x - shape.width/2, y - shape.height/2);
    //shape(shape, x,y);
  }
  if(parseShape) {
    shape(shape, toolX - shape.width/2, toolY - shape.height/2);
    if(child == null) {
      child = shape.getChild(childIndex);
      while(child.getVertexCount() == 0) {
        child = shape.getChild(childIndex);
          childIndex++;   
          if(childIndex > shape.getChildCount()-1) {
            childIndex = 0;
            parseShape = false; 
          }     
      }
      beginPlot();
    } else {
      PVector p = child.getVertex(vertexIndex);
      plotVertex(p.x + toolX - shape.width/2, p.y + toolY - shape.height/2);
      vertexIndex++;
      if(vertexIndex > child.getVertexCount()-1) {
                endPlot();
        child = null;
        vertexIndex = 0;
        childIndex++;
        if(childIndex > shape.getChildCount()-1) {
          childIndex = 0;
          parseShape = false; 
        }
      }
    }
  }
  if(mousePressed && placeShape) {
    toolX = transformMouseX();
    toolY = transformMouseY();
    vertexIndex = 0;
    childIndex = 0;
    parseShape = true;
    placeShape = false;
    println(shape.getChildCount());
    println(shape.getVertexCount());
    if(shape.getChildCount() == 0)
      child = shape;
  }
  
  if(updateDisplay) {
    drawList.render();
    traceList.render();
  }
  renderCurrentLine();
  
  
  popMatrix();
  
  if (gotResponse > 0 && !paused) {
    if (commandList.size() > 0) {
      String g = commandList.get(0);
      if(serialConnected) {
        port.write(g + '\n');
      } else {
        println("[not connected!] > " + g);
      }
      gotResponse --;
      commandList.remove(0);
      gcode.add(g);
      if(monitorGcode)
        println(g);
    } else if (drawList.l.size() > 0) {
      getCommands(); 
    }
  }
  
}


void serialEvent(Serial p) {

  String s = p.readStringUntil('\n');
  if (s != null)
    if(monitorGcode)
      print("~ " + s.trim());

  if (s.trim().startsWith("start")) {
    startupCommands();
    println();
  } else if (s.trim().startsWith("ok")) {
    gotResponse ++;
    if(monitorGcode)
      println(" " + gotResponse);
  } else {
    println();
  }
}


void keyPressed() {

  if (key == 'n') {
    cleanTool(); 
  }
  
  if (key == '`') {
    updateDisplay = !updateDisplay; 
  }
  
  if (key == 'm') {
    println("tracing bounds");
    commandList.add(STOP);    
    commandList.add("G01 X"+ 0 +" Y"+ 0 +" F " + feedrateTravel);  
    commandList.add("G01 X"+ pageWidth +" Y"+ 0 +" F " + feedrateTravel); 
    commandList.add(START);
    commandList.add("G04 P2000"); 
    commandList.add(STOP);    
    commandList.add("G01 X"+ pageWidth +" Y"+ pageHeight +" F " + feedrateTravel); 
    commandList.add(START); 
    commandList.add("G04 P2000");
    commandList.add(STOP);    
    commandList.add("G01 X"+ 0 +" Y"+ pageHeight +" F " + feedrateTravel);  
    commandList.add(START);
    commandList.add("G04 P2000");
    commandList.add(STOP);    
    commandList.add("G01 X"+ 0 +" Y"+ 0 +" F " + feedrateTravel);
    commandList.add(START);
    commandList.add("G04 P2000");
    commandList.add(STOP);
  }
  
  if (keyCode == DOWN) {               // Inverted for the wall plotter
    commandList.add(STOP + '\n'); 
  }
  if (keyCode == UP) {
    commandList.add(START + '\n'); 
  }
  
  if (key == 'h') {
    commandList.add(STOP + '\n');    
    commandList.add(HOME + '\n');
    //commandList.add("G01 X"+ 0 +" Y"+ 0 +" F " + feedrateTravel + '\n');     
  }

  if (key == ' ') {
    zoom = 1;
    panX = cpWidth;
    panY = 0;
    //background(255);
  }

  if (key == 'c') {
    clearPaths();
  }

  if (key == 'p') {
    paintMode = !paintMode; 
    
  }
  
  if (key == 's') {
    /* */
  }

  if (key == 'b') {
    /* */
  }

  if (key == 'z') {
    /* */
  }
  
  if (key == 'x') {
    exportGcode(); 
  }
  
  if (key == 'q') {
    int a = drawList.l.size();
    for(int i=0; i<a; i++) {
      DrawPoint p = drawList.l.get(0);
      traceList.l.add(p);
      drawList.l.remove(0);
    }
  }
  
}

float transformMouseX() {
  return((mouseX + translateX - viewportMargin - panX)/scale);
}

float transformMouseY() {
  return((-mouseY + translateY + viewportMargin + panY)/scale);
}

void mousePressed() {
  if(paintMode) {
    if(!draw)
      beginPlot();
  }
}

void mouseReleased() {
  if(paintMode) {
    float x = transformMouseX();
    float y = transformMouseY();      
    applyTool(paintTool,x,y);
    endPlot();
  }
}