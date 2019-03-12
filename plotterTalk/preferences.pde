

void loadDefaults() {

  feedrateDraw = 4500;
  feedrateTravel = 4500;
  startDelay = 70;
  stopDelay = 0;
  acceleration = 100;
  maxAcceleration = 3000;
  maxFeedrate = 20000;
  pageWidth = 940;
  pageHeight = 640;
  scale = 1.0;
  disableClipping = false;

}


void savePreferences() {

  String[] preferences = {
    "// PLOTTER SETTINGS =================================================== //",
    "feedrateDraw=" + feedrateDraw,
    "feedrateTravel=" + feedrateTravel,
    "// delay to wait for pen to drop before drawing line (millis)",
    "startDelay=" + startDelay,
    "// delay before lifting pen at end of line",
    "stopDelay=" + stopDelay,
    "acceleration=" + acceleration,
    "maxAcceleration=" + maxAcceleration,
    "maxFeedrate=" + maxFeedrate,
    "",
    "// PAGE SETTINGS ====================================================== //",
    "// size of sheet in mm",
    "pageWidth=" + pageWidth,
    "pageHeight=" + pageHeight,
    "disableClipping=" + (disableClipping ? 1 : 0),
    "// pixels per mm",
    "scale=" + scale
  };
  saveStrings("preferences.txt", preferences);

}


void loadPreferences() {

  String data[] = new String[0];
  File preferences = new File(sketchPath("preferences.txt"));
  if (preferences.exists())  {
    data = loadStrings(preferences);
    parsePreferences(data);
  } else {
    println("no preferences file found, loading defaults");
    loadDefaults();
    savePreferences();
    println("saved new prefrences file");
  }
}


void parsePreferences(String[] data) {

  ArrayList<String> vars = new ArrayList<String>();

  for(int i=0; i<data.length; i++) {
    int h = data[i].indexOf("=");
    if (h>0) {
      vars.add(data[i].substring(0,h));
      data[i] = data[i].substring(h+1);
    } else {
      vars.add(data[i]);
    }
  }
  
  // bools
  disableClipping = Integer.parseInt(data[vars.indexOf("disableClipping")]) > 0 ? true : false;

  // strings
  // [example] arduinoPort = data[vars.indexOf("arduinoPort")];
  
  // ints
  feedrateDraw = Integer.parseInt(data[vars.indexOf("feedrateDraw")]);
  feedrateTravel = Integer.parseInt(data[vars.indexOf("feedrateTravel")]);
  startDelay = Integer.parseInt(data[vars.indexOf("startDelay")]);
  stopDelay = Integer.parseInt(data[vars.indexOf("stopDelay")]);
  acceleration = Integer.parseInt(data[vars.indexOf("acceleration")]);
  maxAcceleration = Integer.parseInt(data[vars.indexOf("maxAcceleration")]);
  maxFeedrate = Integer.parseInt(data[vars.indexOf("maxFeedrate")]);
  pageWidth = Integer.parseInt(data[vars.indexOf("pageWidth")]);
  pageHeight = Integer.parseInt(data[vars.indexOf("pageHeight")]);

  // floats
  scale = Float.parseFloat(data[vars.indexOf("scale")]);

}