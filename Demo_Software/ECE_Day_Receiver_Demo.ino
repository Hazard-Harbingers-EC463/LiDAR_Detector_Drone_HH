#include <SPI.h>

//Radio Head Library:
#include <RH_RF95.h>
#include <RHMesh.h>
#include <SD.h>
// RFM95 module's chip select and interrupt pins -> CS = 12 ISR = 6.
RH_RF95 rf95(12, 6);
RHMesh manager(rf95, 1);
int LED = 13;  //Status LED on pin 13

int packetCounter = 0;         //Counts the number of packets sent
long timeSinceLastPacket = 0;  //Tracks the time stamp of last packet received
// The broadcast frequency is set to 921.2
// 902-928MHz in the US.

float frequency = 921.2;
int file_ind = 0;
bool is_init = 0;
int measure_index = 0;
File myFile;


void setup() {
  // initialize Serial Connection 
  SerialUSB.begin(9600);
  while (!SerialUSB);
  // initialize SD
  // SerialUSB.println("Initializing SD...");
  // if (!SD.begin(A4)) {
  //   SerialUSB.println("initialization failed!");
  //   while (1);
  // }
  // SerialUSB.println("SD init successful");

  pinMode(LED, OUTPUT);

  //Initialize the Radio.
  //SerialUSB.println("Initializing LoRa Transceiver");
  if (rf95.init() == false) {
    SerialUSB.println("Radio Init Failed - Freezing");
    while (1);
  } else {
    // An LED indicator to let us know radio initialization has completed.
    //SerialUSB.println("Receiver up!");
    digitalWrite(LED, HIGH);
    delay(500);
    digitalWrite(LED, LOW);
    delay(500);
  }

  rf95.setFrequency(frequency);

  //  SerialUSB.println("Startup Successful...");

}

void loop() {
  if (!is_init){
    //SerialUSB.println("i, T, P, H, GR, Stat");
    SerialUSB.print(measure_index);
    measure_index++;
    SerialUSB.print(',');

    is_init = 1;
  }
  if (rf95.available()) {
    // Should be a message for us now
    uint8_t buf[RH_RF95_MAX_MESSAGE_LEN];
    uint8_t len = sizeof(buf);
    if (rf95.recv(buf, &len)) {
      timeSinceLastPacket = millis();  //Timestamp this packet
      if (buf[0] == '1' && buf[1] =='7'){
        SerialUSB.println((char*)buf);
        SerialUSB.print(measure_index);
        measure_index++;
        SerialUSB.print(',');
      }
      else {
        SerialUSB.print((char*)buf);
        SerialUSB.print(',');
      }
      //SerialUSB.print(" RSSI: ");
      //SerialUSB.print(rf95.lastRssi(), DEC);
      
    } else
      SerialUSB.println("No Data Avail");
  }
}