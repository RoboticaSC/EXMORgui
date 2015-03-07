// PROCESSING CORE
import processing.core.PApplet;

// CONTROLP5 - Interfaces gráficas "prefabricadas" en Processing
import controlP5.*;


// ARDUINO - Uso de la Arduino con Processing (doc: http://playground.arduino.cc/Interfacing/Processing)
import cc.arduino.*;

import processing.serial.*;

Arduino arduino;
ControlP5 cp5;
  
int pi1 = 0;  // Valor potenciómetro índice 1; falange proximal (0-1023)
int pi2 = 0;  // Valor potenciómetro índice 2; falange media (0-1023)
int rx = 0, ry = 0, sx = 0, sy = 0;
float alpha = 0, beta = 0;  // Ángulos (en radianes) de flexión de las falanges de cada dedo

  /**
   * Función principal que ejecuta su código al iniciar el programa una única vez
   * 
   * @name setup
   */
   void setup() {
    // Configuración incial de la ventana
    background(100);
    size(600, 350);
    strokeWeight(30);
    stroke(255, 160);
    
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
    background(100);

    // Lectura de valores desde la Arduino
    pi1 = arduino.analogRead(1);
    pi2 = arduino.analogRead(2);

    cp5.getController("indice1").setValue(int(map(pi1, 0, 1023, 0, 180)));
    cp5.getController("indice2").setValue(int(map(pi2, 0, 1023, 0, 180)));
    // Mirar esto para el suavizado de las entradas: https://processing.org/examples/easing.html

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

  void indice1(float val){
    arduino.servoWrite(9, int(val));
  }
  
  void indice2(float val){
    arduino.servoWrite(10, int(val));
  }
