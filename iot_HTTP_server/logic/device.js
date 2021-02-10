'use strict'

const Device = require('../models/device')
const mqtt = require('../mqtt')

// Retrieve all devices within the system
function getDevices (req, res) {
  Device.find({}, (err, device) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!device) return res.status(404).send({message:'There are no devices registered'})

    res.status(200).send({device})
  })
}

// retrieve a device by his unique identifier
function getDeviceById (req, res) {
  let deviceId = req.params.deviceId

  Device.findById(deviceId, (err, device) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!device) return res.status(404).send({message:'Device does not exist'})

    res.status(200).send({device})
  })
}

// retrieve all devices of a specific device type
function getDevicesByType (req, res) {
  let deviceType = req.params.deviceType

  Device.find({deviceType: deviceType}, (err, device) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!device) return res.status(404).send({message:'There are no devices registered'})

    res.status(200).send({device})
  })
}

// retrieve all devices in a specific room
function getDevicesByRoom (req, res) {
  let room = req.params.room

  Device.find({room: room}, (err, device) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!device) return res.status(404).send({message:'There are no devices registered'})

    res.status(200).send({device})
  })
}

// Registers a device in the system, saving it in the Database
function registerDevice (req, res) {
  console.log('POST /api/device')
  console.log(req.body)

  let device = new Device()

  // Subscribe to the device responding topic
  mqtt.subscribe(req.body.respondingTopic)

  // Store device in the Database
  device.name = req.body.name
  device.deviceType = req.body.deviceType
  device.status = req.body.status
  device.room = req.body.room
  device.receivingTopic = req.body.receivingTopic
  device.respondingTopic = req.body.respondingTopic

  device.save((err, deviceStored) => {
    if (err) res.status(500).send({message: `Error during saving to database: ${err}`})

    res.status(200).send({device: deviceStored})
  })
}

// Updates an existing device within the system
function updateDevice (req, res) {
  let deviceId = req.params.deviceId
  let update = req.body

  Device.findByIdAndUpdate(deviceId, update, {new: true}, (err, deviceUpdated) => {
    if (err) return res.status(500).send({message: `Error at updating device: ${err}`})

    res.status(200).send({device: deviceUpdated})
  })
}

// Deletes a device from the system, removing from the Database
function deleteDevice (req, res) {
  let deviceId = req.params.deviceId

  Device.findById(deviceId, (err, device) => {
    if (err) return res.status(500).send({message: `Error at deleting device: ${err}`})
    if(!device) return res.status(404).send({message:'Device does not exist'})

    // Unsubscribe from the topic (stop listening)
    mqtt.unsubscribe(device.respondingTopic);

    // Remove device from the database
    device.remove(err => {
      if (err) return res.status(500).send({message: `Error at deleting device: ${err}`})

      res.status(200).send({message: 'Device has been deleted'})
    })
  })
}

module.exports = {
  getDevices,
  getDeviceById,
  updateDevice,
  deleteDevice,
  registerDevice,
  getDevicesByType,
  getDevicesByRoom
}
