'use strict'

const mqtt = require('mqtt');

// Create a client and connect to CloudMQTT
var client = mqtt.connect( 'hairdresser.cloudmqtt.com', {
  host: 'hairdresser.cloudmqtt.com',
  port: 15720,
  username: 'ocyeyzzp',
  password: 'VDHkF95QJPAl',
  clientId: 'pda-home-automation',
  protocol: 'MQTT'
});

//  Configure and Connect to MQTT broker at starting application
client.on('connect', function() {
   // When connected
    console.log("Connected to CloudMQTT");

    client.publish("mytopic1", "up", function() {
        console.log("'on' published at start");

    });


});

//handle incoming messages
client.on('message',function(topic, message, packet){
	console.log("message is "+ message);
	console.log("topic is "+ topic);
});

// Handle errors
client.on("error",function(error){
console.log("Can't connect" + error);
process.exit(1)});

// Subscribes to a topic
function subscribe (topic) {
  client.subscribe(topic, function() {
    console.log(`Subscribed to ${topic}`);
  });
}

// Unsubscribes from a topic
function unsubscribe (topic) {
  client.unsubscribe(topic, function() {
    console.log(`Unsubscribed to ${topic}`);
  });
}

// Publishes a message to a topic
function publish (topic, message) {
  // console.log("Trying to publish... Are we connected?");
  //   console.log(client.connected);
  // if (client.connected == true){
  //   client.publish(topic, message, function() {
  //       console.log("Message is published");
  //   });
  // }
  client.publish(topic, message, function() {
      console.log("Message is published");
      res.writeHead(204, { 'Connection': 'keep-alive' });
      res.end();
  });
}

module.exports = { mqtt, publish, subscribe, unsubscribe}
