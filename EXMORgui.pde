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

int[] p = new int[8]; // Valor de cada potenciómetro (analógico, 0 - 1023)

int[] colors = { #FF312E, #104547, #000103, #191D32, #FFFFFA }; // Códigos de color por dedo (orden: índice >> meñique): rojo, turquesa, negro, azul, blanco

int[] min = new int[8]; // Valores máximos de apertura por falange (analógicos, 0 1023), inicializado por defecto a 0
int[] max = { 1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023 }; // Valores máximos de cierre por falange (analógicos, 0 1023)

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
      case 3:
        setBounds(0, 0, 520, 250);  
        final calibApplet c = new calibApplet();
        add(c);
        c.init();
        addWindowListener(new WindowAdapter() {
          public void windowClosing(WindowEvent evt) {
            c.dispose();
          }
        });
        break;
    }
    show();
  }
}

public class settingsApplet extends PApplet {

  ControlP5 settcp5;

  void setup() {
    settcp5 = new ControlP5(this);

    // Generación dinámica de botones (tantos como puertos COM)
    short n;
    int length = 0;
    length = Arduino.list().length;

    Group settGroup = settcp5.addGroup("settings")
      .setPosition(20, 25)
      .setSize(345, 220)
      .disableCollapse()
      .setBackgroundColor(180);

    DropdownList comLB = settcp5.addDropdownList("puertos")
      .setPosition(30, 65)
      .setSize(200, 120)
      .setBarHeight(30)
      .setItemHeight(30);
    comLB.captionLabel().style().marginTop = 10;

    Button calibButton = settcp5.addButton("calibracion")
      .setPosition(30, 80)
      .setSize(200, 50);

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

    if(theEvent.isController()) {
      String controllerName = theEvent.controller().name();

      if(controllerName == "calibracion") {
        PFrame calibration = new PFrame(3);
      }
    }
  }
}

public class graphsApplet extends PApplet {

  int lastTime;
  int x = 41;
  int[] oldY = { 320, 320, 320, 320 };
  int avg = 0;
  float mapped = 0;
  
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
      for(int m = 0; m < 4; m++) {
        // Impresión del tramo de la gráfica
        stroke(colors[m]);
        strokeWeight(2);
        strokeCap(ROUND);
        avg = (p[m * 2] + p[m * 2 + 1]) / 2;
        mapped = map(avg, min[m], max[m], 330, 30);

        line(x - 1, oldY[m], x, (int)mapped);

        x++;
        if(x > 549) { x = 41; background(100); } // La línea ha llegado al final de la gráfica

        lastTime = millis();
        oldY[m] = (int)mapped;
      }
    }
  }
}

public class calibApplet extends PApplet {

  ControlP5 calibcp5;

  boolean ok1 = false;
  boolean ok2 = false;

  void setup() {
    calibcp5 = new ControlP5(this);

    Button done = calibcp5.addButton("hecho")
      .setPosition(430, 160)
      .setSize(40, 30)
      .align(ControlP5.CENTER, ControlP5.CENTER, ControlP5.CENTER, ControlP5.CENTER);
  }

  void draw() {
    background(100);
    fill(255);
    textSize(18);
    text("SISTEMA DE CALIBRACIÓN AUTOMÁTICA", 30, 30);

    fill(0);
    textSize(12);
    text("Abra la mano al máximo.", 40, 50);
    text("Cuando haya terminado, pulse 'HECHO'.", 40, 65);
    if(ok1 == true) {
      if(max[0] == 1023) {
        for(int i = 0; i < 8; i++) {
          max[i] = p[i];
        }
      }

      fill(50);
      text("Valores máximos: " + max[0] + " | " + max[1] + " | " + max[2] + " | " + max[3] + " | " + max[4] + " | " + max[5] + " | " + max[6] + " | " + max[7], 50, 80);

      fill(0);
      text("Ahora, cierre la mano lo máximo posible.", 40, 100);
      text("Al acabar, pulse 'HECHO'.", 40, 115);

      if(ok2 == true) {
        if(min[0] == 0) {
          for(int i = 0; i < 8; i++) {
            min[i] = p[i];
          }
        }

        fill(50);
        text("Valores mínimos: " + min[0] + " | " + min[1] + " | " + min[2] + " | " + min[3] + " | " + min[4] + " | " + min[5] + " | " + min[6] + " | " + min[7], 50, 130);

        fill(0);
        text("Calibración completa. Puede cerrar esta ventana.", 40, 150);
      }
    }
  }

  void controlEvent(ControlEvent theEvent) {
    if(theEvent.isController()) {
      String controllerName = theEvent.controller().name();

      if(controllerName == "hecho") {
        if(ok1 != true) {
          ok1 = true;
        } else if(ok2 != true) {
          ok2 = true;
        }
      }
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
    .setRange(0, 120)
    .setColorForeground(colors[0]);
    
  Slider ind2 = cp5.addSlider("indice2")
    .setPosition(10, 243)
    .setSize(200, 20)
    .setRange(0, 120)
    .setColorForeground(colors[0]);

  Slider cor1 = cp5.addSlider("corazon1")
    .setPosition(10, 273)
    .setSize(200, 20)
    .setRange(0, 120)
    .setColorForeground(colors[1]);
    
  Slider cor2 = cp5.addSlider("corazon2")
    .setPosition(10, 303)
    .setSize(200, 20)
    .setRange(0, 120)
    .setColorForeground(colors[1]);

  Slider anu1 = cp5.addSlider("anular1")
    .setPosition(10, 333)
    .setSize(200, 20)
    .setRange(0, 120)
    .setColorForeground(colors[2]);
    
  Slider anu2 = cp5.addSlider("anular2")
    .setPosition(10, 363)
    .setSize(200, 20)
    .setRange(0, 120)
    .setColorForeground(colors[2]);

  Slider men1 = cp5.addSlider("menique1")
    .setPosition(10, 393)
    .setSize(200, 20)
    .setRange(0, 120)
    .setColorForeground(colors[3]);
    
  Slider men2 = cp5.addSlider("menique2")
    .setPosition(10, 423)
    .setSize(200, 20)
    .setRange(0, 120)
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

  cp5.getController(dedos[dedo] + "1").setValue(int(map(p[dedo1Index], min[dedo1Index], max[dedo1Index], 0, 120)));
  cp5.getController(dedos[dedo] + "2").setValue(int(map(p[dedo2Index], min[dedo2Index], max[dedo2Index], 0, 120)));
  // Mirar esto para el suavizado de las entradas: https://processing.org/examples/easing.html

  strokeWeight(30);
  stroke(colors[dedo], 160);

  // Cálculo y muestreo de la representación gráfica del dedo
  alpha = map(p[dedo1Index], min[dedo1Index], max[dedo1Index], 0, PI);
  ry = int(sin(alpha) * 80);
  rx = int(cos(alpha) * 80);
  line(350, 200, rx + 350, ry + 200);
  beta = map(p[dedo2Index], min[dedo1Index], max[dedo1Index], 0, PI) + alpha;
  sy = int(sin(beta) * 80) + ry;
  sx = int(cos(beta) * 80) + rx;
  line(rx + 350, ry + 200, sx + 350, sy + 200);
}
