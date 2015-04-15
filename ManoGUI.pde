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

int pi1 = 0;  // Valor potenciómetro índice 1; falange proximal (0-1023)
int pi2 = 0;  // Valor potenciómetro índice 2; falange media (0-1023)
int rx = 0, ry = 0, sx = 0, sy = 0;
float alpha = 0, beta = 0;  // Ángulos (en radianes) de flexión de las falanges de cada dedo

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
        .setPosition(100, 150 + 40 * n)
        .setSize(200, 30)
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
        println("Created button 'com " + n + "'");
    }
  }

  void draw() {

  }

}

short chosenCOMIndex = 2; // Número de índice del array de puertos COM donde está la Arduino

/**
 * Función principal que ejecuta su código al iniciar el programa una única vez
 * 
 * @name setup
 */
void setup() {
  // Configuración incial de la ventana
  size(650, 450);
  
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

  Button sett = cp5.addButton("opciones")
    .setPosition(628, 7)
    .setSize(30, 30)
    .setLabelVisible(false)
    .setImage(loadImage("gearw.png")) // De Flaticon.com - Egor Rumyantsev
    .setColorBackground(200);
}

/**
 * Función principal que ejecuta su código en un bucle infinito hasta que el programa se cierra
 * 
 * @name draw
 */
void draw() {
  background(100);

  // TO-DO: Convertir fuente a ttf
  PFont OpenSans = loadFont("OpenSans-Regular.vlw");

  // Lectura de valores desde la Arduino
  pi1 = arduino.analogRead(1);
  pi2 = arduino.analogRead(2);

  image(loadImage("user.png"), 10, 50, 100, 123);
  textFont(OpenSans, 22);
  text("Nombre Apellido Apellido", 120, 90);
  textSize(17);
  fill(150);
  text("#123456", 130, 115);
  text("Afección", 130, 135);

  cp5.getController("indice1").setValue(int(map(arduino.analogRead(1), 0, 1023, 0, 180)));
  cp5.getController("indice2").setValue(int(map(arduino.analogRead(2), 0, 1023, 0, 180)));
  // Mirar esto para el suavizado de las entradas: https://processing.org/examples/easing.html

  stroke(0);
  fill(0);
  rect(0, 0, 650, 30);
  fill(150);
  textSize(15);
  text("ManoGUI | ", 5, 20);
  fill(255);
  text("Arduino configurada en: " + Arduino.list()[chosenCOMIndex], 88, 20);

  strokeWeight(30);
  stroke(255, 160);

  // Cálculo y muestra de la representación gráfica del dedo
  alpha = map(pi1, 0, 1023, 0, 2 * PI);
  ry = int(sin(alpha) * 80);
  rx = int(cos(alpha) * 80);
  line(350, 200, rx + 350, ry + 200);
  beta = map(pi2, 0, 1023, 0, 2 * PI) + alpha;
  sy = int(sin(beta) * 80) + ry;
  sx = int(cos(beta) * 80) + rx;
  line(rx + 350, ry + 200, sx + 350, sy + 200);
}


/**
  * Gestor de eventos del slider "indice1" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name indice1
  * @param val  nuevo valor del slider
  */
void indice1(float val) {
  arduino.servoWrite(9, int(val));
}

/**
  * Gestor de eventos del slider "indice2" (se ejecuta cada vez que el valor del slider cambia)
  *
  * @name indice2
  * @param val  nuevo valor del slider
  */
void indice2(float val) {
  arduino.servoWrite(10, int(val));
}

void opciones(int val) {
  PFrame f = new PFrame();
}
