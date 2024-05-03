#include <Wire.h>
#include <SPI.h>
#include <Adafruit_Sensor.h>
#include "bme68xLibrary.h"
#include <RH_RF95.h>


#define BME_SCK 13
#define BME_MISO 12
#define BME_MOSI 11
#define BME_CS 10

#define SEALEVELPRESSURE_HPA (1013.25)
#define PIN_CS A4

float frequency = 921.2;       //Broadcast frequency

Bme68x bme;
RH_RF95 rf95(12, 6);

void setup() {
  SerialUSB.begin(9600);
  SPI.begin();
  while (!Serial)
    ;
  Serial.println(F("BME688 test"));

  if (rf95.init() == false) {
    SerialUSB.println("Radio Init Failed - Freezing");
    while (1)
      ;
  } else {
    SerialUSB.println("Transceiver up!");
  }

  rf95.setFrequency(frequency);
  rf95.setTxPower(14, false);

  bme.begin(PIN_CS, SPI);
  if (bme.checkStatus() == BME68X_ERROR) {
    //SerialUSB.println("Sensor error:" + bme.statusString());
    return;
  } else if (bme.checkStatus() == BME68X_WARNING) {
    //SerialUSB.println("Sensor Warning:" + bme.statusString());
  }
  bme.setTPH();
  bme.setHeaterProf(300, 100);
}


char temp[6];
char press[10];
char hum[6];
char gr[9];
char stat[3];

bme68xData data;
int i = 0;
void loop() {

  SerialUSB.println("Before Fetch");
  bme.setOpMode(BME68X_FORCED_MODE);
  //delayMicroseconds(bme.getMeasDur());
  if (bme.fetchData()) {
    bme.getData(data);

    String(data.temperature).toCharArray(temp, 6);
    String(data.pressure).toCharArray(press, 10);
    String(data.humidity).toCharArray(hum, 6);
    String(data.gas_resistance).toCharArray(gr, 9);
    String(data.status).toCharArray(stat, 3);

    //SerialUSB.print(String(millis()) + ", ");
    //rf95.send((uint8_t *)((millis())), sizeof(char) * 5);
    //rf95.waitPacketSent();

    SerialUSB.print(String(data.temperature) + ", ");
    rf95.send((uint8_t *)(temp), sizeof(char) * 6);
    rf95.waitPacketSent();

    SerialUSB.print(String(data.pressure) + ", ");
    rf95.send((uint8_t *)(press), sizeof(char) * 10);
    rf95.waitPacketSent();

    SerialUSB.print(String(data.humidity) + ", ");
    rf95.send((uint8_t *)(hum), sizeof(char) * 6);
    rf95.waitPacketSent();

    SerialUSB.print(String(data.gas_resistance) + ", ");
    rf95.send((uint8_t *)(gr), sizeof(char) * 9);
    rf95.waitPacketSent();

    SerialUSB.println(data.status, HEX);
    rf95.send((uint8_t *)(stat), sizeof(char) * 3);
    rf95.waitPacketSent();

    SerialUSB.println();
  }
  delay(1000);
}