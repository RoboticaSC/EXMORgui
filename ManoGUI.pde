// JFRAME - Permite tener múltiples ventanas
import javax.swing.JFrame;

// CONTROLP5 - Interfaces gráficas "prefabricadas" en Processing
import controlP5.*;

// ARDUINO - Uso de la Arduino con Processing (doc: http://playground.arduino.cc/Interfacing/Processing)
import cc.arduino.*;

// PROCESSING SERIAL - Requisito de la librería de Arduino (comunicación vía serial)
import processing.serial.*;

public class PFrame extends JFrame {
  public PFrame() {
    setBounds(0, 0, 100, 200);
    additionalApplet a = new additionalApplet();
    add(a);
    a.init();
    show();
  }
}

public class additionalApplet extends PApplet {
  public void setup() {
    size(100, 512);
    background(0);
  }
}

static Arduino arduino;
static ControlP5 cp5;
  
/**
 * Función principal que ejecuta su código al iniciar el programa una única vez
 * 
 * @name setup
 */
void setup() {
  // Configuración incial de la ventana
  background(100);
  size(600, 300);
  
  // Inicialización de la Arduino
  println("Arduino list: " + Arduino.list()[1]); // DEBUG
  arduino = new Arduino(this, Arduino.list()[1]);
  
  // Inicialización de la interfaz ControlP5
  cp5 = new ControlP5(this);
  
  cp5.addSlider("indice1")
    .setPosition(10, 10)
    .setSize(100, 20)
    .setRange(0, 180);
    
  cp5.addSlider("indice2")
    .setPosition(10, 40)
    .setSize(100, 20)
    .setRange(0, 180);
}

/**
 * Función principal que ejecuta su código en un bucle infinito hasta que el programa se cierra
 * 
 * @name draw
 */
void draw() {
  cp5.getController("indice1").setValue(int(map(arduino.analogRead(1), 0, 1023, 0, 180)));
  cp5.getController("indice2").setValue(int(map(arduino.analogRead(2), 0, 1023, 0, 180)));
  // Mirar esto para el suavizado de las entradas: https://processing.org/examples/easing.html
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


// FUNCIÓN DE PRUEBA DE LAS VENTANAS MÚLTIPLES
void mousePressed() {
  PFrame f = new PFrame();
}