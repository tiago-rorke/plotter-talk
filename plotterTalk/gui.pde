

//private ControlP5 cp5;
//ControlFrame cf;

/*
ControlFrame addControlFrame(String _name, int _width, int _height) {
  Frame f = new Frame(_name);
  ControlFrame p = new ControlFrame(this, _width, _height);
  f.add(p);
  p.init();
  f.setTitle(_name);
  f.setSize(p.w, p.h);
  f.setLocation(50, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}
*/

/*
public class ControlFrame extends PApplet {

  ControlP5 cp5;
  Object parent;
  int w, h;
    
  public void setup() {
    size(w, h);
    //frameRate(25);
    
    cp5 = new ControlP5(this);
    
    int cpx = 20;
    int cpy = 20;
                                    // min   max     default           X        Y         W     H
                                               
    cp5.addSlider("feedrateDraw",      100,  maxFeedrate,  feedrateDraw,     cpx,     cpy,      140,  10).plugTo(parent,"feedrateDraw")  .setLabel("Drawing Feedrate");
    cp5.addSlider("feedrateTravel",    100,  maxFeedrate,  feedrateTravel,   cpx,     cpy+20,   140,  10).plugTo(parent,"feedrateTravel").setLabel("Moving Feedrate");
    cp5.addSlider("startDelay",        0,    1000,   startDelay,       cpx,     cpy+40,   140,  10).plugTo(parent,"startDelay")    .setLabel("Start Draw Delay");
    cp5.addSlider("stopDelay",         0,    1000,   stopDelay,        cpx,     cpy+60,   140,  10).plugTo(parent,"stopDelay")     .setLabel("Stop Draw Delay");
    cp5.addSlider("acceleration",      0,    maxAcceleration,   acceleration,     cpx,     cpy+80,   140,  10).plugTo(parent,"acceleration")  .setLabel("Acceleration");
    
    //cp5.addSlider("amplitude",         0,    100,    amplitude,        cpx,     cpy+130,  140,  10).plugTo(parent,"amplitude")  .setLabel("Sound Amplitude Scale");
    //cp5.addSlider("timescale",         0,    100,    timescale,        cpx,     cpy+150,  140,  10).plugTo(parent,"amplitude")  .setLabel("Sound Time Scale");
    
    cp5.addToggle("pause",                                             cpx,     cpy+130,  50,   20).plugTo(parent,"pause")      .setLabel("Pause").setMode(ControlP5.SWITCH);
    cp5.addButton("clear",             1,                              cpx+70,  cpy+130,  50,   20).plugTo(parent,"clearPaths") .setLabel("Clear");
    cp5.addButton("home",              1,                              cpx+140, cpy+130,  50,   20).plugTo(parent,"home")       .setLabel("Home");
    cp5.addToggle("paintMode",                                         cpx,     cpy+170,  50,   20).plugTo(parent,"paintMode")  .setLabel("Paint Mode");
    cp5.addButton("loadSVG",           1,                              cpx+70,  cpy+170,  50,   20).plugTo(parent,"loadSVG")    .setLabel("Open SVG");
    
    cp5.addRadioButton("paintTool")
       .setPosition(cpx,250)
       .setSize(20,20)
       .setItemsPerRow(2)
       .setSpacingColumn(50)
       .addItem("draw",0)
       .addItem("line",1)
       .addItem("rectangle",2)
       .addItem("circle",3)
       .addItem("orbit",4)
       .addItem("dots",5)
       .addItem("text",6)
       .plugTo(parent,"paintTool")
       .activate(0)
       ;
    
    cp5.addTextfield("textInput").setPosition(cpx, cpy+330).setLabel("Text");;
    cp5.addSlider("textSize",          0,    100,   textSize,           cpx,     cpy+370,   140,  10).plugTo(parent,"textSize")  .setLabel("Text Size");
      
    
  }

  public void draw() {
    background(100);
  }
  
  private ControlFrame() {
  }

  public ControlFrame(Object _parent, int _width, int _height) {
    parent = _parent;
    w = _width;
    h = _height;
  }

  public ControlP5 control() {
    return cp5;
  }
  
}
*/


void initGUI() {
    
    int cpx = 20;
    int cpy = 20;
                                    // min   max     default           X        Y         W     H
                                               
    cp5.addSlider("feedrateDraw",      100,  maxFeedrate,  feedrateDraw,     cpx,     cpy,      140,  10).setLabel("Drawing Feedrate");
    cp5.addSlider("feedrateTravel",    100,  maxFeedrate,  feedrateTravel,   cpx,     cpy+20,   140,  10).setLabel("Moving Feedrate");
    cp5.addSlider("startDelay",        0,    1000,   startDelay,       cpx,     cpy+40,   140,  10).setLabel("Start Draw Delay");
    cp5.addSlider("stopDelay",         0,    1000,   stopDelay,        cpx,     cpy+60,   140,  10).setLabel("Stop Draw Delay");
    cp5.addSlider("acceleration",      0,    maxAcceleration,   acceleration,     cpx,     cpy+80,   140,  10).setLabel("Acceleration");
    
    //cp5.addSlider("amplitude",         0,    100,    amplitude,        cpx,     cpy+130,  140,  10).setLabel("Sound Amplitude Scale");
    //cp5.addSlider("timescale",         0,    100,    timescale,        cpx,     cpy+150,  140,  10).setLabel("Sound Time Scale");
    
    cp5.addToggle("pause",                                             cpx,     cpy+130,  50,   20).setLabel("Pause").setMode(ControlP5.SWITCH);
    cp5.addButton("clear",             1,                              cpx+70,  cpy+130,  50,   20).setLabel("Clear");
    cp5.addButton("home",              1,                              cpx+140, cpy+130,  50,   20).setLabel("Home");
    cp5.addToggle("paintMode",                                         cpx,     cpy+170,  50,   20).setLabel("Paint Mode");
    cp5.addButton("loadSVG",           1,                              cpx+70,  cpy+170,  50,   20).setLabel("Open SVG");
    
    cp5.addRadioButton("paintTool")
       .setPosition(cpx,250)
       .setSize(20,20)
       .setItemsPerRow(2)
       .setSpacingColumn(50)
       .addItem("draw",0)
       .addItem("line",1)
       .addItem("rectangle",2)
       .addItem("circle",3)
       .addItem("orbit",4)
       .addItem("dots",5)
       .addItem("text",6)
       .activate(0)
       ;
    
    cp5.addTextfield("textInput").setPosition(cpx, cpy+330).setLabel("Text");;
    cp5.addSlider("textSize",          0,    100,   textSize,           cpx,     cpy+370,   140,  10).setLabel("Text Size");
      
}

// ============================ //

/*
void controlEvent(ControlEvent event) { 

  if(event.isFrom(cf.cp5.get(Textfield.class,"input")))    {
    paintText = cp5.get(Textfield.class,"input").getText();
  }
}*/


void feedrateDraw(int val) {
  feedrateDraw = val;
  println("feedrateDraw = " + feedrateDraw);
  //commandList.add("G1 F" + feedrateDraw + '\n'); 
}

void feedrateTravel(int val) {
  feedrateTravel = val;
  println("feedrateTravel = " + feedrateTravel);
  //commandList.add("G0 F" + feedrateTravel + '\n'); 
}

void acceleration(int val) {
  acceleration = val;
  println("acceleration = " + acceleration);
  commandList.add("M204 S" + acceleration + " T"  + acceleration + '\n'); 
}


void startDelay(int val) {
  startDelay = val;
  println("startDelay = " + startDelay);
}


void stopDelay(int val) {
  stopDelay = val;
  println("stopDelay = " + stopDelay);
}

void clearPaths() {
  clearPaths = true;
}

void home() {
  commandList.add(STOP + '\n');    
  commandList.add(HOME + '\n');
}

void pause(boolean flag) {
  paused = flag;
  if(paused)
    cp5.getController("pause").setLabel("Play");
  else
    cp5.getController("pause").setLabel("Pause");
}

void paintTool(int i) {
  paintTool = i;
}

public void loadSVG() {

  FileDialog fd = new FileDialog(frame, "open", FileDialog.LOAD);
  String currentDir = new File(".").getAbsolutePath();

  fd.pack();
  fd.show();

  if (fd.getName() != null) {

    String filename = fd.getFile();
    PShape svg = loadShape(fd.getDirectory() + filename);
    //svg.disableStyle();
    //svg.setStroke(toolLineColor);
    //svg.setStrokeWeight(toolLineWeight);
    shape = svg;
    //shape.rotate(PI);
    placeShape = true;
    
  }
  
}