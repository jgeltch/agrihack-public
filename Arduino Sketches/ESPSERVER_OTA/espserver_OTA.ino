#include <DHT.h>
#include <DHT_U.h>
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include <ESP8266WebServer.h>
#define BOARDLED 2
#define FANPIN   4
#define HEATPIN  0
#define COOLPIN  14

#define DHT11PIN 5
#define BTNPIN   12
const char* ssid = "ssid";
const char* password = "password";
ESP8266WebServer server(80);
DHT dht(DHT11PIN, DHT11);

void setup() {
  Serial.begin(115200); //init serial
  Serial.println("Booting"); 
  WiFi.mode(WIFI_STA); //Act as a wifi client
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED){
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
  pinMode(BOARDLED, OUTPUT); //BOARD LED, FIXED
  pinMode(FANPIN  , OUTPUT); //FAN + FAN ACTIVE LED
  pinMode(HEATPIN , OUTPUT); //HEATING + HEATING ACTIVE LED
  pinMode(COOLPIN , OUTPUT); //COOLING + COOLING ACTIVE LED
  pinMode(DHT11PIN, INPUT);  //D1, DHT11
  pinMode(BTNPIN  , INPUT);  //BUTTON PIN. SET HIGH ON PRESSED
}

void loop() {
  //ArduinoOTA.handle();
  Serial.println(WiFi.localIP()); //Prints IP to serial port.
  //------Actual code starts here
  server.on("/rawdata", void server.send(200, "text/html", "Testing!!"));
  server.begin();
}

String serveJSON()
{
  int temp = dht.readHumidity();
  int humidity = dht.readTemperature();
  String htmlPage =
     String("HTTP/1.1 200 OK\r\n") +
            "Content-Type: text/html\r\n" +
            "Connection: close\r\n" +  // the connection will be closed after completion of the response
            "\r\n" +
            "{temp:"+ temp + ",humidity:"+humidity+"}"
            "\r\n";
  if (isnan(dht.readHumidity()))
  {
    return "HTTP/1.1 500 INTERNAL SERVER ERROR\r\n";
  }
  else
  {
    return htmlPage;
  }
}

