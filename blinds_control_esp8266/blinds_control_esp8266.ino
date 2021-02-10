#define _DEBUG_

#include "ESP8266WiFi.h"
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <PubSubClient.h>

//// Device class and attributes
//class Device {
//  public:
//  char* name = "blinds_001";
//  const char* deviceType = "blinds";
//  char* state;
//  bool isFree = true;
//};

//Device *device;

// Network configuration
const char* networkName = "GlobalVeronaE3";
const char* networkPwd = "JonSnowviuaXaloc6";

// MQTT configuration
const char* brokerUrl = "hairdresser.cloudmqtt.com";
int mqttPort = 15720;
const char* userMQTT = "ocyeyzzp";
const char* pwdMQTT = "VDHkF95QJPAl";
const char* brokerInstance = "pda-home-automation";
const char* mqttTopicReceive = "mytopic1";
const char* mqttTopicRespond = "otherTopic";
const char* mqttTopicScanReceive = "scan/devices";
const char* mqttTopicScanRespond = "confirm/free";

//WiFiClient and PubSubClient instances
WiFiClient espClient;
PubSubClient mqttClient(espClient);


void setup() {

//  device = new Device();

  // Set up inputs
  pinMode(D5, INPUT);
  pinMode(D6, INPUT);
  pinMode(D7, INPUT);
  
  // Set up outputs
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);

  digitalWrite(D1,HIGH);
  digitalWrite(D2, HIGH);
  
  Serial.begin(115200);

  // Connect to Network
  wifiConnect();

  mqttClient.setServer(brokerUrl, mqttPort);
  mqttClient.setCallback(callback);
}

void wifiConnect(){
  #ifdef _DEBUG_
    Serial.println();
    Serial.println("Starting network connection"); 
    Serial.print(networkName);
  #endif
  
   // Set up Network Connection
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(100);

  WiFi.begin(networkName, networkPwd);
  
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    
    #ifdef _DEBUG_
      Serial.print(".");
    #endif
  }
  Serial.println();

  #ifdef _DEBUG_
    Serial.println("Connected, IP address: ");
    Serial.print(WiFi.localIP());
  #endif
}

void mqttConnect() {
  while (!mqttClient.connected()) {
    Serial.println("Attempting MQTT connection...");
    // Attempt to connect
    if (mqttClient.connect(brokerInstance, userMQTT, pwdMQTT)){
      Serial.println("Connected!");
  
      // Subscribe
      mqttClient.subscribe(mqttTopicReceive);
      Serial.print("Subscribed to: ");
      Serial.println(mqttTopicReceive);
      
      mqttClient.subscribe(mqttTopicScanReceive);
      Serial.print("Subscribed to: ");
      Serial.println(mqttTopicScanReceive);

    } else {
      Serial.println("Failed: ");
      Serial.print(mqttClient.state());
      Serial.println("Try again in 5 seconds");
  
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void callback(char* topic, byte* message, unsigned int length) {
  Serial.print("Message arrived on topic: ");
  Serial.print(topic);
  Serial.print(". Message: ");
  String messageStr;

  for (int i = 0; i < length; i++) {
    Serial.print((char)message[i]);
    messageStr += (char)message[i];
  }
  Serial.println();

  if (String(topic) == mqttTopicReceive) {
    
    digitalWrite(D1, LOW);
    digitalWrite(D2, HIGH);
    if (messageStr == "up") {
      
      setBlindsDown();
      Serial.println("SET BLINDS UP");
      // Send response
      char payload[12] = "blinds-up";
      mqttClient.publish(mqttTopicRespond, payload);
      Serial.println("Message published");
      
    } else if (messageStr == "down") {
      
      Serial.println("SET BLINDS DOWN");
      setBlindsUp();
      // Send response
      char payload[12] = "blinds-down";
      mqttClient.publish(mqttTopicRespond, payload);
      
    } else if (messageStr == "stop") {
      
      Serial.println("STOP BLINDS");
      stopBlinds();
      // Send response
      char payload[12] = "blinds-stop";
      mqttClient.publish(mqttTopicRespond, payload);
      
    } else {
      
      Serial.println("INVALID MESSAGE");
      stopBlinds();
      // Send response
      char payload[12] = "invalid-msg";
      mqttClient.publish(mqttTopicRespond, payload);
      
    }
  } 
//  else if ( String(topic) == mqttTopicScanReceive) {
//    if (messageStr == "who is free?" && device->isFree) {
//      // Send response
//      char payload[12];
//      sprintf(payload,"%s/%s",device->name,device->deviceType);
//      //mqttClient.publish(mqttTopicScanRespond, payload);
//    } else if (messageStr == "you are now registered" && device->isFree) {
//      device->isFree = false;
//    }
//    
//  }
}

void loop() {
  //if (WiFi.status() == WL_CONNECTED) {
    if (!mqttClient.connected()) {
      mqttConnect();
    }

//    int stopButtonVal = digitalRead(D5);
//    if(stopButtonVal == HIGH) {
//      Serial.println("STOP BUTTON PRESSED!!!");
//      stopBlinds();
//    }
//
//    int upButtonVal = digitalRead(D6);
//    if(upButtonVal == HIGH) {
//      Serial.println("UP BUTTON PRESSED!!!");
//      setBlindsUp();
//    }
//
//    int downButtonVal = digitalRead(D7);
//    if(downButtonVal == HIGH) {
//      Serial.println("DOWN BUTTON PRESSED!!!");
//      setBlindsDown();
//    }

    mqttClient.loop();

    delay(250);
 }

 void setBlindsDown(){
    #ifdef _DEBUG_
      Serial.println("Setting blinds down");
    #endif
  
  digitalWrite(D1, LOW);
  digitalWrite(D2, LOW);
  //delay(15000);
  //digitalWrite(D2, HIGH);
 }


 void setBlindsUp(){
    #ifdef _DEBUG_
      Serial.println("Setting blinds up");
    #endif

  digitalWrite(D1, HIGH);
  digitalWrite(D2, LOW);
  //delay(15000);
  //digitalWrite(D2, HIGH);
 }

  void stopBlinds(){
    #ifdef _DEBUG_
      Serial.println("Stopping blinds");
    #endif

    digitalWrite(D2, HIGH);
    digitalWrite(D1, HIGH);
 }
