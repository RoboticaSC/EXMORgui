// JFRAME - Permite tener múltiples ventanas
import javax.swing.JFrame;

// JAVA AWT EVENTS - Para detectar cuándo se ha cerrado una ventana
import java.awt.event.*;

// CONTROLP5 - Interfaces gráficas "prefabricadas" en Processing
import controlP5.*;

// ARDUINO - Uso de la Arduino con Processing (doc: http://playground.arduino.cc/Interfacing/Processing)
import cc.arduino.*;

// PROCESSING SERIAL - Requisito de la librería de Arduino (comunicación vía serial)
import processing.serial.*;

Arduino arduino;
ControlP5 cp5;

int[] p = new int[8];

int[] colors = { #FF312E, #104547, #000103, #191D32, #FFFFFA };

public class PFrame extends JFrame {

  /**
   * Constructor de la clase PFrame
   *
   * @name PFrame
   * @param 
   */
  public PFrame(int frame) {
    switch(frame) {
      case 1:
        setBounds(0, 0, 400, 300);
        final settingsApplet s = new settingsApplet();
        add(s);
        s.init();
        addWindowListener(new WindowAdapter() {
          public void windowClosing(WindowEvent evt) {
            s.dispose();
          }
        });
        break;
      case 2:
        setBounds(0, 0, 600, 430);
        final graphsApplet g = new graphsApplet();
        add(g);
        g.init();
        addWindowListener(new WindowAdapter() {
          public void windowClosing(WindowEvent evt) {
            g.dispose();
          }
        });
        break;
    }
    show();
  }
}

public class settingsApplet extends PApplet {

  ControlP5 comcp5;

  void setup() {
    comcp5 = new ControlP5(this);

    // Generación dinámica de botones (tantos como puertos COM)
    short n;
    int length = 0;
    length = Arduino.list().length;

    Group settGroup = comcp5.addGroup("settings")
      .setPosition(20, 25)
      .setSize(345, 220)
      .disableCollapse()
      .setBackgroundColor(180);

    DropdownList comLB = comcp5.addDropdownList("puertos")
      .setPosition(30, 65)
      .setSize(200, 120)
      .setBarHeight(30)
      .setItemHeight(30);
    comLB.captionLabel().style().marginTop = 10;

    for(n = 0; n < length; n++) { // 1 elemento es 1 en length, por lo que se utiliza < y no <=
      comLB.addItem(Arduino.list()[n], n);
    }
  }

  void draw() {
    background(150);
  }

  void controlEvent(ControlEvent theEvent) {
    if(theEvent.isGroup()) {
      String groupName =  theEvent.group().name();

      if(groupName == "puertos") {  // Desplegable de los puertos COM, en el menú de opciones
        chosenCOMIndex = (int)theEvent.group().value();
      }
    }
  }
}

public class graphsApplet extends PApplet {
  int lastTime;
  int i = 41;
  int oldY = 320;
  
  void setup() {
    background(100);
    lastTime = millis();
    textSize(14); 
  }

  void draw() {
    smooth(8);
    // Muestreo del marco de la gráfica
    stroke(0);
    strokeWeight(3);
    line(30, 330, 550, 330);  // Eje X
    line(40, 30, 40, 340);  // Eje Y
    rotate(PI);
    text("ROTACIÓN", 0, 0);
    rotate(-PI);
    text("TIEMPO", 270, 350);

    if(millis() >= lastTime + 10) { // Comprueba que ya ha pasado el tiempo entre impresiones
      // Impresión del tramo de la gráfica
      stroke(#2B3A67);
      strokeWeight(2);
      strokeCap(ROUND);
      line(i - 1, oldY, i, p[0]);

      i++;
      if(i > 549) { i = 41; background(100); } // La línea ha llegado al final de la gráfica

      lastTime = millis();
      oldY = p[0];
    }
  }

}

int chosenCOMIndex = Arduino.list().length - 1; // Número de índice del array de puertos COM donde está la Arduino

/**
 * Función principal que ejecuta su código al iniciar el programa una única vez
 * 
 * @name setup
 */
void setup() {
  // Configuración incial de la ventana
  size(650, 460);

  // Inicialización de la Arduino
  println("Arduino list: " + Arduino.list()[chosenCOMIndex]); // DEBUG
  arduino = new Arduino(this, Arduino.list()[chosenCOMIndex]);

  // Inicialización de la interfaz ControlP5
  cp5 = new ControlP5(this);

  Slider ind1 = cp5.addSlider("indice1")
    .setPosition(10, 213)
    .setSize(200, 20)
    .setRange(0, 180)
    .setColorForeground(colors[0]);
    
  Slider ind2 = cp5.addSlider("indice2")
    .setPosition(10, 243)
    .setSize(200, 20)
    .setRange(0, 180)
    .setColorForeground(colors[0]);

  Slider cor1 = cp5.addSlider("corazon1")
    .setPosition(10, 273)
    .setSize(200, 20)
    .setRange(0, 180)
    .setColorForeground(colors[1]);
    
  Slider cor2 = cp5.addSlider("corazon2")
    .setPosition(10, 303)
    .setSize(200, 20)
    .setRange(0, 180)
    .setColorForeground(colors[1]);

  Slider anu1 = cp5.addSlider("anular1")
    .setPosition(10, 333)
    .setSize(200, 20)
    .setRange(0, 180)
    .setColorForeground(colors[2]);
    
  Slider anu2 = cp5.addSlider("anular2")
    .setPosition(10, 363)
    .setSize(200, 20)
    .setRange(0, 180)
    .setColorForeground(colors[2]);

  Slider men1 = cp5.addSlider("menique1")
    .setPosition(10, 393)
    .setSize(200, 20)
    .setRange(0, 180)
    .setColorForeground(colors[3]);
    
  Slider men2 = cp5.addSlider("menique2")
    .setPosition(10, 423)
    .setSize(200, 20)
    .setRange(0, 180)
    .setColorForeground(colors[3]);

  Button sett = cp5.addButton("opciones")
    .setPosition(628, 7)
    .setSize(30, 30)
    .setLabelVisible(false)
    .setImage(loadImage("gearw.png")) // De Flaticon.com - Egor Rumyantsev
    .setColorBackground(200);

  Button graph = cp5.addButton("graficas")
    .setPosition(550, 45)
    .setSize(80, 40)
    .align(ControlP5.CENTER, ControlP5.CENTER, ControlP5.CENTER, ControlP5.CENTER);
}

/**
 * Función principal que ejecuta su código en un bucle infinito hasta que el programa se cierra
 * 
 * @name draw
 */
void draw() {
  background(100);

  PFont OpenSans = loadFont("OpenSans-Regular.vlw");

  image(loadImage("user.png"), 10, 50, 100, 123);
  textFont(OpenSans, 22);
  text("Nombre Apellido Apellido", 120, 90);
  textSize(17);
  fill(150);
  text("#123456", 130, 115);
  text("Afección", 130, 135);

  stroke(0);
  fill(0);
  rect(0, 0, 650, 15);
  fill(150);
  textSize(15);
  text("EXMOR | ", 5, 20);
  fill(255);
  text("Arduino configurada en: " + Arduino.list()[chosenCOMIndex], 75, 20);
  
  for(short i = 0; i < 4; i++) { // Representación gráfica de todos los dedos
    imprimirDedo(i);
  }
}

/**
  * Gestor de eventos de todos los elementos del programa
  *
  * @name controlEvent
  * @param theEvent evento que ha invocado la función
  */
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isController()) {
    String controllerName = theEvent.controller().name();

    // Sliders de los dedos
    if(controllerName == "indice1") {
      arduino.servoWrite(9, int(theEvent.controller().value()));
    } else if(controllerName == "indice2") {
      arduino.servoWrite(10, int(theEvent.controller().value()));
    } else if(controllerName == "corazon1") {
      arduino.servoWrite(11, int(theEvent.controller().value()));
    } else if(controllerName == "corazon2") {
      arduino.servoWrite(12, int(theEvent.controller().value()));
    } else if(controllerName == "anular1") {
      arduino.servoWrite(13, int(theEvent.controller().value()));
    } else if(controllerName == "anular2") {
      arduino.servoWrite(14, int(theEvent.controller().value()));
    } else if(controllerName == "menique1") {
      arduino.servoWrite(15, int(theEvent.controller().value()));
    } else if(controllerName == "menique2") {
      arduino.servoWrite(16, int(theEvent.controller().value()));
    } else if(controllerName == "opciones") { // Botón de opciones (rueda dentada)
      PFrame sett = new PFrame(1);
    } else if(controllerName == "graficas") {
      PFrame graph = new PFrame(2);
    }
  }
}

/**
  * Realiza la lectura de un dedo y muestra su representación gráfica con el color correspondiente
  *
  * @name imprimirDedo
  * @param dedo Número de 0 a 3, que representa el índice del dedo, siendo 0 el índice, y 3 el meñique
  */
void imprimirDedo(short dedo) {
  String[] dedos = { "indice", "corazon", "anular", "menique" };
  int p1 = 0;  // Valor potenciómetro falange proximal (0-1023)
  int p2 = 0;  // Valor potenciómetro falange media (0-1023)
  int rx = 0, ry = 0, sx = 0, sy = 0;
  float alpha = 0, beta = 0;  // Ángulos (en radianes) de flexión de las falanges de cada dedo
  int dedo1Index = dedo * 2 + 1;
  int dedo2Index = dedo * 2;

  // Lectura de valores desde la Arduino
  p[dedo1Index] = arduino.analogRead(dedo1Index);
  p[dedo2Index] = arduino.analogRead(dedo2Index);

  cp5.getController(dedos[dedo] + "1").setValue(int(map(p[dedo1Index], 0, 1023, 0, 180)));
  cp5.getController(dedos[dedo] + "2").setValue(int(map(p[dedo2Index], 0, 1023, 0, 180)));
  // Mirar esto para el suavizado de las entradas: https://processing.org/examples/easing.html

  strokeWeight(30);
  stroke(colors[dedo], 160);

  // Cálculo y muestreo de la representación gráfica del dedo
  alpha = map(p[dedo1Index], 0, 1023, 0, 2 * PI);
  ry = int(sin(alpha) * 80);
  rx = int(cos(alpha) * 80);
  line(350, 200, rx + 350, ry + 200);
  beta = map(p[dedo2Index], 0, 1023, 0, 2 * PI) + alpha;
  sy = int(sin(beta) * 80) + ry;
  sx = int(cos(beta) * 80) + rx;
  line(rx + 350, ry + 200, sx + 350, sy + 200);
}