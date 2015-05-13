// JFRAME - Permite tener múltiples ventanas
import javax.swing.JFrame;

// CONTROLP5 - Interfaces gráficas "prefabricadas" en Processing
import controlP5.*;

// ARDUINO - Uso de la Arduino con Processing (doc: http://playground.arduino.cc/Interfacing/Processing)
import cc.arduino.*;

// PROCESSING SERIAL - Requisito de la librería de Arduino (comunicación vía serial)
import processing.serial.*;

static Arduino arduino;
static ControlP5 cp5;

public class PFrame extends JFrame {
  public PFrame() {
    setBounds(0, 0, 400, 300);
    additionalApplet a = new additionalApplet();
    add(a);
    a.init();
    show();
  }
}

public class additionalApplet extends PApplet {
  ControlP5 comcp5;

  void setup() {
    comcp5 = new ControlP5(this);
    background(150);

    // Generación dinámica de botones (tantos como puertos COM)
    short n;
    int length = 0;
    length = Arduino.list().length;
    for(n = 0; n <= length; n++) {
      comcp5.addButton("com" + n)
        .setPosition(100, 120 + 40 * n)
        .setSize(200, 30)
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
        println("Created button 'com " + n + "'");
    }
  }

  void draw() {

  }

}

short chosenCOMIndex = 1; // Número de índice del array de puertos COM donde está la Arduino

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
    .setRange(0, 180);
    
  Slider ind2 = cp5.addSlider("indice2")
    .setPosition(10, 243)
    .setSize(200, 20)
    .setRange(0, 180);

  Slider cor1 = cp5.addSlider("corazon1")
    .setPosition(10, 273)
    .setSize(200, 20)
    .setRange(0, 180);
    
  Slider cor2 = cp5.addSlider("corazon2")
    .setPosition(10, 303)
    .setSize(200, 20)
    .setRange(0, 180);

  Slider anu1 = cp5.addSlider("anular1")
    .setPosition(10, 333)
    .setSize(200, 20)
    .setRange(0, 180);
    
  Slider anu2 = cp5.addSlider("anular2")
    .setPosition(10, 363)
    .setSize(200, 20)
    .setRange(0, 180);

  Slider men1 = cp5.addSlider("menique1")
    .setPosition(10, 393)
    .setSize(200, 20)
    .setRange(0, 180);
    
  Slider men2 = cp5.addSlider("menique2")
    .setPosition(10, 423)
    .setSize(200, 20)
    .setRange(0, 180);

  Button sett = cp5.addButton("opciones")
    .setPosition(628, 7)
    .setSize(30, 30)
    .setLabelVisible(false)
    .setImage(loadImage("gearw.png")) // De Flaticon.com - Egor Rumyantsev
    .setColorBackground(200);
}

short i = 0;  // Contador para bucles

/**
 * Función principal que ejecuta su código en un bucle infinito hasta que el programa se cierra
 * 
 * @name draw
 */
void draw() {
  background(100);

  // TO-DO: Convertir fuente a ttf
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
  text("ManoGUI | ", 5, 20);
  fill(255);
  text("Arduino configurada en: " + Arduino.list()[chosenCOMIndex], 88, 20);
  
  for(i = 0; i < 4; i++) { // Representación gráfica de todos los dedos
    imprimirDedo(i);
  }
}

/**
  * Gestor de eventos del slider "indice1" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name indice1
  * @param val nuevo valor del slider
  */
void indice1(float val) {
  arduino.servoWrite(9, int(val));
}

/**
  * Gestor de eventos del slider "indice2" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name indice2
  * @param val nuevo valor del slider
  */
void indice2(float val) {
  arduino.servoWrite(10, int(val));
}

/**
  * Gestor de eventos del slider "corazon1" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name corazon1
  * @param val nuevo valor del slider
  */
void corazon1(float val) {
  arduino.servoWrite(11, int(val));
}

/**
  * Gestor de eventos del slider "corazon2" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name corazon2
  * @param val nuevo valor del slider
  */
void corazon2(float val) {
  arduino.servoWrite(12, int(val));
}

/**
  * Gestor de eventos del slider "anular1" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name anular1
  * @param val nuevo valor del slider
  */
void anular1(float val) {
  arduino.servoWrite(13, int(val));
}

/**
  * Gestor de eventos del slider "anular2" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name anular2
  * @param val nuevo valor del slider
  */
void anular2(float val) {
  arduino.servoWrite(14, int(val));
}

/**
  * Gestor de eventos del slider "menique1" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name menique1
  * @param val nuevo valor del slider
  */
void menique1(float val) {
  arduino.servoWrite(15, int(val));
}

/**
  * Gestor de eventos del slider "menique2" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name menique2
  * @param val nuevo valor del slider
  */
void menique2(float val) {
  arduino.servoWrite(16, int(val));
}

void opciones(int val) {
  PFrame f = new PFrame();
}

/**
  * Realiza la lectura de un dedo y muestra su representación gráfica con el color correspondiente
  *
  * @name imprimirDedo
  * @param dedo Número de 0 a 3, que representa el índice del dedo, siendo 0 el índice, y 3 el meñique
  */
void imprimirDedo(short dedo) {
  int[] colors = { #FF312E, #104547, #000103, #191D32, #FFFFFA };
  String[] dedos = { "indice", "corazon", "anular", "menique" };
  int p1 = 0;  // Valor potenciómetro índice 1; falange proximal (0-1023)
  int p2 = 0;  // Valor potenciómetro índice 2; falange media (0-1023)
  int rx = 0, ry = 0, sx = 0, sy = 0;
  float alpha = 0, beta = 0;  // Ángulos (en radianes) de flexión de las falanges de cada dedo

  // Lectura de valores desde la Arduino
  p1 = arduino.analogRead(dedo * 2 + 1);
  p2 = arduino.analogRead(dedo * 2 + 2);

  cp5.getController(dedos[dedo] + "1").setValue(int(map(p1, 0, 1023, 0, 180)));
  cp5.getController(dedos[dedo] + "2").setValue(int(map(p2, 0, 1023, 0, 180)));
  // Mirar esto para el suavizado de las entradas: https://processing.org/examples/easing.html

  strokeWeight(30);
  stroke(colors[dedo], 160);

  // Cálculo y muestra de la representación gráfica del dedo
  alpha = map(p1, 0, 1023, 0, 2 * PI);
  ry = int(sin(alpha) * 80);
  rx = int(cos(alpha) * 80);
  line(350, 200, rx + 350, ry + 200);
  beta = map(p2, 0, 1023, 0, 2 * PI) + alpha;
  sy = int(sin(beta) * 80) + ry;
  sx = int(cos(beta) * 80) + rx;
  line(rx + 350, ry + 200, sx + 350, sy + 200);
}

/*
    16/04/15 - Jueves
    TO-DO:
      - Calibrar la relación analógica-grados
      - Evitar que se mueva el anillo de la falange distal, especialmente en dedos finos
      - Mejoras en el cableado
      - Menú puertos COM funcional (y con el COM real, no el index number)
*/

/*
    08/05/15 - Viernes
    TO-DO:
      - Organizar en funciones la lectura y muestreo de la representación del dedoç
      - Poner el nombre real del COM en el selector de puerto, y no el número de índice
*/