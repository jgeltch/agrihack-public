#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

const char* ssid = "ssid";
const char* password = "password";

void setup() {
  Serial.begin(115200); //init serial
  Serial.println("Booting"); 
  WiFi.mode(WIFI_STA); //Act as a wifi client
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  ArduinoOTA.onStart([]() {
    Serial.println("Start");
  });
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
    Serial.printf("Progress: %u%%\r", (progress / (total / 100)));    //Serial Progress indicator
  });
  ArduinoOTA.begin();
  Serial.println("Ready");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP()); //Prints IP to serial port.
  //---------Actual setup starts here
  pinMode(2, OUTPUT); //Prep GPIO2 (LED) for output.
}

void loop() {
  ArduinoOTA.handle();
  //------Actual code starts here
  digitalWrite(2, HIGH);
  delay(500);
  digitalWrite(2, LOW);
  delay(500);
}

