# smart_home
This is a (unfinished) IoT smart home project that I worked on during the COVID-19 pandemic, specifically during the first lockdown in Spain (March 20 - May-20). Check out the images and demo videos!

It consists of an IoT server using that uses HTTP and MQTT to communicate with IoT devices and a mobile application (iOS). For this, I built:
- A javascript server that handles MQTT communication from devices to talk to your IoT smart home devices via MQTT.
- A iOS application using Swift where you could manage your devices and accionate them, sending your orders to the server. I only developed a very simple (and ugly) version, I had plans to design a better interface and my sister actually made a mockup, but had no time to implement it.
- An IoT device that is able to wirelessly operate blinds (up, down and pause) using an ESP8266 board, relays and some sensors. It is programmed using Arduino since ESP8266 allows for it, and it recieves commands via MQTT from the server.

The project is unfinished since I was woring at the time and the lockdown ended for the summer. I built it so it is scalable to new devices and, in the future, the system could be improved and extended.  


