#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <DHT.h>
#include <FS.h>
#include <DHT_U.h>
#define BOARDLED 2
#define FANPIN   4
#define HEATPIN  0
#define COOLPIN  14
//input
#define DHT11PIN 5
#define BTNPIN   12
//thresholds
#define lowhumid 52
#define hihumid  65
#define lowtemp  15
#define besttemp 22
#define hitemp   24
int LOWHUMID = lowhumid;
int HIHUMID = hihumid;
int LOWTEMP = lowtemp;
int BESTTEMP = besttemp;
int HITEMP = hitemp;
ESP8266WebServer server(80);
DHT dht(DHT11PIN, DHT11);
bool fanactive = false;
bool heatactive = false;
bool coolactive = false;
void setup() {
 
  Serial.begin(115200);
  WiFi.begin("ssid", "password");  //Connect to the WiFi network
 
  while (WiFi.status() != WL_CONNECTED) {  //Wait for connection
 
    delay(500);
    Serial.println("Waiting to connect…");
 
  }
 
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());  //Print the local IP
 
  server.on("/other", []() {   //Define the handling function for the path
    server.send(200, "text / plain", "Other URL");

  });
  server.on("/rawdata", handleRawDataRequest);    //Associate the handler function to the path
  if (!SPIFFS.begin())
  {
    Serial.println("SPIFFS Mount failed.");
  } else {
    Serial.println("SPIFFS Mount succeeded.");
  }
  
  server.serveStatic("/", SPIFFS, "/index.html");
  server.serveStatic("/js", SPIFFS, "/js");
  server.begin();                                       //Start the server
  Serial.println("Server listening");

  pinMode(BOARDLED, OUTPUT); //BOARD LED, FIXED
  pinMode(FANPIN  , OUTPUT); //FAN + FAN ACTIVE LED
  pinMode(HEATPIN , OUTPUT); //HEATING + HEATING ACTIVE LED
  pinMode(COOLPIN , OUTPUT); //COOLING + COOLING ACTIVE LED
  pinMode(DHT11PIN, INPUT);  //D1, DHT11
  pinMode(BTNPIN  , INPUT);  //BUTTON PIN. SET HIGH ON PRESSED
}
 
void loop() {
 
  server.handleClient();         //Handling of incoming requests
  //Start monitoring LEDs
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  //-----------HUMIDITY FAN CONTROL------
  if (humidity > HIHUMID)
  {
    fanactive = true;
    digitalWrite(FANPIN, HIGH);
  }
  else if (fanactive)
  {
    if (humidity < LOWHUMID)
    {
    digitalWrite(FANPIN, LOW);
    fanactive = false;
    }
  }
  //----------------TEMP HEAT CONTROL----
  if (temperature > HITEMP)
  {
    heatactive = true;
    digitalWrite(HEATPIN, HIGH);
  }
  else if (heatactive)
  {
    if (temperature < LOWTEMP)
    {
      heatactive = false;
      digitalWrite(HEATPIN, LOW);
    }
  }
  //------------TEMP COOL CONTROL---------
  
}
 
void handleRawDataRequest() {            //Handler for rawdata request
  
  
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  String data = String()+"{\"temp\":"+temperature+",\"humidity\":"+humidity+",\"humidity\":"+humidity+",\"humidity\":"+humidity+",\"humidity\":"+humidity+"}";
  server.send(200, "text/plain", data);
}
