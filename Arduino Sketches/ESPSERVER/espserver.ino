#include <ESP8266WiFi.h>
#define ssid         "ssid"
#define password     "password"
#define softwarerev  '0.0.1'
WiFiServer server(80);
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.println("Starting ESP8266, code rev" + softwarerev);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.print(serveJSON());
}
String serveJSON()
{
  int temp = 32768;
  int humidity = 32768;
  String htmlPage =
     String("HTTP/1.1 200 OK\r\n") +
            "Content-Type: text/html\r\n" +
            "Connection: close\r\n" +  // the connection will be closed after completion of the response
            "Refresh: 5\r\n" +  // refresh the page automatically every 5 sec
            "\r\n" +
            "{temp:"+ temp + ",humidity:"+humidity+"}"
            "\r\n";
  return htmlPage;
}
