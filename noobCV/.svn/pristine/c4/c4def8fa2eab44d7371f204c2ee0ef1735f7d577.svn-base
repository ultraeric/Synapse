import controlP5.*;
import java.util.LinkedList;

ControlP5 cp5;
ControlP5 cp6;

int mode = 0;
int midX = 1250/2;
int midY = 700/2;
RadioButton time_option;
ControlFont font;
color convC = color(253, 72, 86);
color poolC = color(255, 138, 73);
color reluC = color(255, 194, 73);
color fcC = color(0, 192, 74);
color normC = color(0, 160, 215);
color collapseC = color(185, 99, 248);
color goC = color(0, 186, 144);
color bgC = color(39, 28, 72);
//PFont pfont = new PFont();
ArrayList<Layer> layers = new ArrayList<Layer>();
LinkedList<String> names = new LinkedList<String>();
int layerID = 0;
String toRemove = ""; // save the name of the X button clicked (to remove it next draw iter)
PImage logo;
boolean uploaded_img = false;
PImage testImg;
double validation = -1;
double num_pics = -1;

void setup() {
  size(1250, 700);
  PFont pfont = createFont("Verdana", 10, true);
  logo = loadImage("synapse.png");
  logo.resize((int) (logo.width * 0.2), (int)(logo.height * 0.2));
  font = new ControlFont(pfont, 12);
  cp5 = new ControlP5(this);
  cp5.getTooltip().register("time_val", "TESTING.");
  cp5.getTooltip().register("add_conv", "TESTING.");

  cp5.getTooltip().register("s2", "Changes the Background");
  cp6 = new ControlP5(this);

  //put all labels into names;
  for (int i = 0; i < 100; i++) {
    names.add("" + i);
  }

  //setup layers
  layers.add(new ConvLayer(3, 1, 4, 4));
  layers.add(new ReLULayer());
  layers.add(new ConvLayer(3, 1, 8, 4));
  layers.add(new ReLULayer());
  layers.add(new PoolLayer(3));
  layers.add(new CollapseLayer(256));
  layers.add(new FCLayer(256, 256));
  layers.add(new FCLayer(256, 2));
  layers.add(new NormalizationLayer());

  //setup gui for settings
  setup_settings(true);
}

void draw() {
  if (!toRemove.equals("")) {
    //cp5.getController(toRemove).remove();
    //System.out.println("REMOVED " + toRemove);
    toRemove = "";
  }
  if (mode == 0) {
    draw_settings();
  } else if (mode == 1) {
    draw_status();
  }
}

void draw_settings() {
}

void draw_status() {
  background(bgC);
  image(logo, 0, 15);

  if (testImg != null) {
    image(testImg, midX, midY);
  }
  if (validation != -1) {
    //textFont(pFont);
    text("Validation success rate: " + validation, 200, 200);
  }
  if (num_pics != -1) {
    text("Number of pictures processed: " + num_pics, 200, 300);
  }

  try {
    String filename = "../settings/result.json";
    JSONObject json;
    json = loadJSONObject(filename);
    System.out.println(json);
    // print values
    String result = json.getString("result");
    if (uploaded_img){
      text("The network thinks this is a picture of: " + result, midX, midY-50);
    }
  } 
  catch (Exception e) {
    System.out.println("Exception: " + e);
  }
}
void add_button(String label, int i, int x, int y, int width, int height) {
  PImage a = loadImage("" + i + ".png");
  PImage b = loadImage("" + i + "_1.png");
  PImage c = loadImage("" + i + "_2.png");
  a.resize(width, height);
  b.resize(width, height);
  c.resize(width, height);
  cp5.addButton(label)
    .setPosition(x, y)
    .setSize(width, height)
    .setImages(a, b, c)
    ;
}
void setup_settings(boolean initial) {
  if (mode == 1) return;
  noStroke();
  background(bgC);
  // draw in logo
  image(logo, 0, 15);

  // If first run, draw in all static controllers (non-layers)
  if (initial) {
    // draw in hyperparams
    int hyper_y = 120;
    int hyper_x = 20;
    int h = 25;
    int w = 40;
    time_option = cp5.addRadioButton("time_option")
      .setPosition(hyper_x, hyper_y)
      .setSize(15, 15)
      .setItemsPerRow(5)
      .setSpacingColumn(40)
       .setColorValue(color(255, 255, 255))
       .setColorBackground(color(255, 255, 255))
      .addItem("time", 1)
      .addItem("epoch", 2)
      .addItem("per", 3)
      ;
    cp5.addTextfield("time_val").setPosition(hyper_x+ w * 4, hyper_y-5).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("");
    cp5.addTextfield("dim_x").setPosition(hyper_x, hyper_y + h).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("image width");
    cp5.addTextfield("dim_y").setPosition(hyper_x+ 2 * w, hyper_y + h).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("image height");
    cp5.addTextfield("max_epoch").setPosition(hyper_x + 4 * w, hyper_y + h).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("max epoch");
    //cp5.addTextfield("category_loc_1").setPosition(hyper_x, hyper_y + 3 * h).setSize(w * 4, h).setColorBackground(bgC).getCaptionLabel().setText("Category 1 location");
    //cp5.addTextfield("category_loc_2").setPosition(hyper_x + w * 5, hyper_y + 3 * h).setSize(w * 4, h).setColorBackground(bgC).getCaptionLabel().setText("Category 2 location");

    // draw in buttons
    int buttonY = 200;
    int buttonX = 20;
    int buttonWidth = 40;
    int buttonHeight = 40;
    int s = buttonWidth + 20;
    add_button("add_conv", 1, buttonX, buttonY, buttonWidth, buttonHeight);
    add_button("add_pool", 2, buttonX + s, buttonY, buttonWidth, buttonHeight);
    add_button("add_relu", 3, buttonX + 2 * s, buttonY, buttonWidth, buttonHeight);
    add_button("add_fc", 4, buttonX + 3 * s, buttonY, buttonWidth, buttonHeight);
    add_button("add_norm", 5, buttonX + 4 * s, buttonY, buttonWidth, buttonHeight);
    add_button("add_collapse", 6, buttonX + 5 * s, buttonY, buttonWidth, buttonHeight);


    // add GO button
    cp5.addButton("GO")
      .setPosition(midX -60, 2 * midY - 60)
      .setSize(120, 40)
      .setColorBackground(goC)
      .setColorActive(color(0, 165, 121))
      .setColorForeground(color(0, 165, 121))
      .getCaptionLabel().setFont(font)
      ;
  }

  // draw in layers
  int layerX = 20;
  int layerWidth = 270;
  int layerHeight = 50;
  int layerY = 270;
  int maxY = 600;
  for (Layer l : layers) {
    color c = getColor(l);
    fill(c);
    rect(layerX, layerY, layerWidth, layerHeight);
    text(l.type, layerX + 20, layerY);
    drawOpts(l, layerX, layerY);
    layerY += layerHeight + 20;
    if (layerY > maxY) {
      layerY = 270;
      layerX = layerX + layerWidth + 30;
    }
  }
}
void setup_status() {
  clear_settings();
  background(bgC);
  System.out.println("Cleared all");
  // draw in logo
  image(logo, 0, 15);

  // draw in model selection
  cp6.addButton("model_select").setPosition(20, 150);

  // draw in img select
  cp6.addButton("image_select").setPosition(20, 200);
}

public void image_selected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String path = selection.getAbsolutePath();
    println("User selected " + path);

    // show img
    testImg = loadImage(path);
    testImg.resize((int)(testImg.width * 0.5), (int)(testImg.height * 0.5));

    // write pic name
    uploaded_img = true;
    PrintWriter output  = createWriter("../settings/test_preprocess.json");
    output.println("{\"pic_path\":\""+selection.getAbsolutePath()+ "\"}");
    output.flush();
    output.close();

    //call preprocess script
    try {
      String commandToRun = "python /Users/ericemily/CS/Projects/hackathon/noobCV/preprocessing.py";
      File workingDir = new File(sketchPath(""));
      Runtime.getRuntime().exec(commandToRun, null, workingDir);
      delay(5000);
    } 
    catch (IOException e) {
      System.out.println("IOException encountered: " + e);
    }
  }
}
public void image_select() {
  selectInput("Select an image:", "image_selected");
}

public void model_selected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    show_status(selection.getAbsolutePath());
  }
}
public void model_select() {
  selectInput("Select a model:", "model_selected");
}

public void show_status(String path) {
  System.out.println("Showing status " + path);
  JSONObject json;
  json = loadJSONObject(path);

  // print values
  validation = json.getDouble("validation");
  System.out.println(validation);
  num_pics = json.getInt("num_pics");
  System.out.println(num_pics);
  String model_name = json.getString("model_name");
  System.out.println(model_name);


  // write model_name
  PrintWriter output  = createWriter("../settings/test_settings.json");
  output.println("{\"model_name\":\""+ model_name + "\"}");
  output.flush(); 
  output.close();
}

public void controlEvent(ControlEvent theEvent) { 
  if (theEvent.isGroup()) {
    System.out.println("radiobutton clicked");
  } else {
    String s = theEvent.getController().getName();
    if (s.length() > 5 && s.substring(0, 5).equals("close")) {
      String id = s.substring(5);
      int toRemove = 0;
      for (int i = 0; i < layers.size(); i++) {
        if (layers.get(i).id.equals(id)) {
          toRemove = i;
        }
      }
      Layer l = layers.remove(toRemove);
      l.free();
    }
    setup_settings(false);
  }
}


void clear_settings() {
  cp5.hide();
}

public void GO(int theValue) {
  String json = "";

  // add all layers
  json += "{\"cnn\":[";
  for (Layer l : layers) {
    l.read();
    json += l.toJson() + ",";
  }
  json = json.substring(0, json.length() -1) + "],";

  // add extra params. Time 
  int tenmil = 10000000;
  int opt = (int)time_option.getValue();
  int val = read_int("time_val");
  if (val == 0) { // by default, snapshot every 30 mins
    opt = 1;
    val = 30;
  }
  if (opt == 1) {
    json += "\"time\":" + (val*60) + ",\"epoch\":" + tenmil + ",\"number\":" + tenmil;
  } else if (opt == 2) {
    json += "\"time\":" + tenmil + ",\"epoch\":" + val + ",\"number\":" + tenmil;
  } else if (opt == 3) {
    json += "\"time\":" + tenmil + ",\"epoch\":" + tenmil + ",\"number\":" + val;
  } else {
    System.out.println("Something went wrong!");
  }

  // add extra params. size
  int x = d(read_int("dim_x"), 200);
  int y = d(read_int("dim_y"), 200);
  json += ",\"size\":[" + x + "," + y + "],";

  // add extra params. Max epoch
  int max_epoch = d(read_int("max_epoch"), 5);
  json += "\"max_epoch\":" + max_epoch + "}";

  // write out
  PrintWriter out = createWriter("../settings/cnn_settings.json");
  out.println(json);
  out.flush(); 
  out.close(); 
  setup_status();

  // change mode to 1
  mode = 1;

  //run scripts
  try {
    String commandToRun = "python3 /Users/ericemily/CS/Projects/hackathon/noobCV/generate_cnn.py";
    File workingDir = new File(sketchPath(""));
    Runtime.getRuntime().exec(commandToRun, null, workingDir);
    System.out.println(1);
    delay(5000);
    System.out.println(2);

    String commandToRun2 = "python3 /Users/ericemily/CS/Projects/hackathon/noobCV/train_cnn.py";
    File workingDir2 = new File(sketchPath(""));
    Runtime.getRuntime().exec(commandToRun2, null, workingDir2);
  } 
  catch (IOException e) {
    System.out.println("IOException: " + e);
  }
}

// get color for given layer
public color getColor(Layer l) {
  switch (l.type) {
  case "conv_layer":
    return convC;
  case "pool":
    return poolC;
  case "fully_connected":
    return fcC;
  case "log_softmax":
    return normC;
  case "relu":
    return reluC;
  case "collapse":
    return collapseC;
  default:
    return bgC;
  }
}

// draw in options for given layer
public void drawOpts(Layer l, int x, int y) {
  x = x + 20;
  y = y + 5;
  int s = 60;
  int h = 25;
  int w = 40;
  int c_x = 20;
  int c_y = 20;
  String close = "close" + l.id;
  if (cp5.getController(close) == null) {
    switch (l.type) {
    case "conv_layer":
      cp5.addTextfield(((ConvLayer) l).ws_id).setPosition(x, y).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("Window size");
      cp5.addTextfield(((ConvLayer) l).ss_id).setPosition(x + s, y).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("Step size");
      cp5.addTextfield(((ConvLayer) l).d_id).setPosition(x + 2*s, y).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("Depth");
      cp5.addTextfield(((ConvLayer) l).ind_id).setPosition(x + 3*s, y).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("In depth");
      break;
    case "pool":
      cp5.addTextfield(((PoolLayer) l).ws_id).setPosition(x, y).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("Window size");
      break;
    case "fully_connected":
      cp5.addTextfield(((FCLayer) l).in_id).setPosition(x, y).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("In size");
      cp5.addTextfield(((FCLayer) l).out_id).setPosition(x + s, y).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("Out size");
      break;
    case "collapse":
      cp5.addTextfield(((CollapseLayer) l).out_id).setPosition(x, y).setSize(w, h).setColorBackground(bgC).getCaptionLabel().setText("Out size");
      break;
    default:
      break;
    }
    cp5.addButton(close).setPosition(x + 3.8*s, y).setSize(c_x, c_y).setColorBackground(bgC).getCaptionLabel().setText("X");
  } else {
    //System.out.println("Moving opts");
    switch (l.type) {
    case "conv_layer":
      cp5.getController(((ConvLayer) l).ws_id).setPosition(x, y);
      cp5.getController(((ConvLayer) l).ss_id).setPosition(x + s, y);
      cp5.getController(((ConvLayer) l).d_id).setPosition(x + 2*s, y);
      cp5.getController(((ConvLayer) l).ind_id).setPosition(x + 3*s, y);
      break;
    case "pool":
      cp5.getController(((PoolLayer) l).ws_id).setPosition(x, y);
      break;
    case "fully_connected":
      cp5.getController(((FCLayer) l).in_id).setPosition(x, y);
      cp5.getController(((FCLayer) l).out_id).setPosition(x + s, y);
      break;
    case "collapse":
      cp5.getController(((CollapseLayer) l).out_id).setPosition(x, y);
      break;
    default:
      break;
    }
    cp5.getController(close).setPosition(x + 3.8*s, y);
  }
}
// convenience function to return default val
public int d(int x, int de) {
  return (x == 0) ? de : x;
}

// convenience function to read int from textfield with given label, return with default
public int read_int(String field) {
  String s = ((Textfield)cp5.getController(field)).getText();
  if (s.equals("")) {
    return 0;
  }
  return Integer.parseInt(s);
}

// Add layer functions
public void add_conv() {
  layers.add(new ConvLayer());
  setup_settings(false);
}

public void add_pool() {
  layers.add(new PoolLayer());
  setup_settings(false);
}

public void add_fc() {
  layers.add(new FCLayer());
  setup_settings(false);
}
public void add_norm() {
  layers.add(new NormalizationLayer());
  setup_settings(false);
}

public void add_relu() {
  layers.add(new ReLULayer());
  setup_settings(false);
}
public void add_collapse() {
  layers.add(new CollapseLayer());
  setup_settings(false);
}

// Layer classes
class Layer { 
  String type;
  String id;
  public Layer(String t) {
    type = t;
    id = ""+layerID;
    layerID++;
  }
  public String toJson() {
    String js = this.json();
    if (js != "") {
      return "{\"name\":\"" + type + "\"," + js + "}";
    } else {
      return "{\"name\":\"" + type + "\"}";
    }
  }

  public void read() {
  }
  public String json() {
    return "";
  }
  public void free() { // delete the buttons related
    toRemove = "close" + id;
    cp5.getController("close" + id).hide();
  }
}
class ConvLayer extends Layer {
  int window_size;
  int step_size;
  int depth;
  int in_depth;
  String ws_id;
  String ss_id;
  String d_id;
  String ind_id;
  public ConvLayer() {
    this(0, 0, 0, 0);
  }
  public ConvLayer(int windowSize, int step_size, int depth, int in_depth) {
    super("conv_layer");
    this.window_size = d(windowSize, 3);
    this.step_size = d(step_size, 1);
    this.depth = d(depth, 4);
    this.in_depth = d(in_depth, 4);
    ws_id = names.pop();
    ss_id = names.pop();
    d_id = names.pop();
    ind_id = names.pop();
  }
  public void read() {
    window_size = d(read_int(ws_id), 3);
    step_size = d(read_int(ss_id), 1);
    depth = d(read_int(d_id), 4);
    in_depth = d(read_int(ind_id), 4);
  }
  public String json() {
    return "\"window_size\":" + window_size + 
      ",\"step_size\":" + step_size +
      ",\"depth\":" + depth + 
      ",\"in_depth\":" + in_depth;
  }
  public void free() {
    names.add(ws_id);
    names.add(ss_id);
    names.add(d_id);
    names.add(ind_id);
    cp5.getController(ws_id).hide();
    cp5.getController(ss_id).hide();
    cp5.getController(d_id).hide();
    cp5.getController(ind_id).hide();
    super.free();
  }
}
class PoolLayer extends Layer {
  int window_size;
  String ws_id;
  public PoolLayer() {
    this(0);
  }
  public PoolLayer(int windowSize) {
    super("pool");
    this.window_size = d(windowSize, 3);
    ws_id = names.pop();
  }
  public void read() {
    window_size = d(read_int(ws_id), 3);
  }
  public String json() {
    return "\"window_size\":" + window_size;
  }
  public void free() {
    names.add(ws_id);
    cp5.getController(ws_id).hide();
    super.free();
  }
}
class FCLayer extends Layer {
  int in, out;
  int default_in = 256;
  int default_out = 256;
  String in_id;
  String out_id;
  public FCLayer() {
    this(0, 0);
  }
  public FCLayer(int in, int out) {
    super("fully_connected");
    this.in = d(in, default_in);
    this.out = d(out, default_out);
    in_id = names.pop();
    out_id = names.pop();
  }
  public void read() {
    in = d(read_int(in_id), in);
    out = d(read_int(out_id), out);
  }
  public String json() {
    return "\"in_size\":" + in + ",\"out_size\":" + out;
  }
  public void free() {
    names.add(in_id);
    names.add(out_id);
    cp5.getController(in_id).hide();
    cp5.getController(out_id).hide();
    super.free();
  }
}
class NormalizationLayer extends Layer {
  public NormalizationLayer() {
    super("log_softmax");
  }
}
class ReLULayer extends Layer {
  public ReLULayer() {
    super("relu");
  }
}
class CollapseLayer extends Layer {
  int out_size;
  String out_id;
  public CollapseLayer() {
    this(0);
  }
  public CollapseLayer(int out) {
    super("collapse");
    this.out_size = d(out, 256);
    out_id = names.pop();
  }
  public void read() {
    out_size = d(read_int(out_id), 256);
  }
  public String json() {
    return "\"out_size\":" + out_size;
  }
  public void free() {
    names.add(out_id);
    cp5.getController(out_id).hide();
    super.free();
  }
}