'use strict'

const Device = require('../models/device')
const Action = require('../models/action')
const mqtt = require('../mqtt')

// Retrieve all actions sent through system
function getActions (req, res) {
  Action.find({}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}

// Retrieve actions sent to a specific device
function getActionsByDeviceId (req, res) {
  let deviceId = req.params.deviceId

  Action.find({deviceId: deviceId}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}


// Retrieve actions sent to devices of a specific type
function getActionsByType (req, res) {
  let deviceType = req.params.deviceType

  Action.find({deviceType: deviceType}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}

// Retrieve actions sent to devices in a specific room
function getActionsByRoom (req, res) {
  let room = req.params.room

  Action.find({room: room}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}

// Registers an action in the Database
function registerAction (req, device, res) {
  console.log('POST /api/device')
  console.log(req.body)

  let action = new Action()
  let date = new Date()

  action.deviceId = req.body.deviceId
  action.newState = req.body.newState
  action.room = device.room
  action.deviceType = device.deviceType
  action.year = date.getUTCFullYear()
  action.month = date.getUTCMonth()
  action.day = date.getUTCDate()
  action.hour = date.getHours()

  action.save((err, actionStored) => {
    if (err) res.status(500).send({message: `Error during saving to database: ${err}`})

    res.status(200).send({action: actionStored})
  })
}

// Sends an action to a device determined by its unique identifier
function sendAction (req, res) {
  console.log('POST /api/action')
  console.log(req.body)

  Device.findById(req.body.deviceId, (err, device) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!device) return res.status(404).send({message:'Device does not exist'})

    mqtt.publish(device.receivingTopic, req.body.newState);

    registerAction(req, device, res)
  })
}

// Deletes a device from the system, removing from the Database
function deleteAction (req, res) {
  let actionId = req.params.actionId

  Action.findById(actionId, (err, action) => {
    if (err) return res.status(500).send({message: `Error at deleting device: ${err}`})
    if(!action) return res.status(404).send({message:'Action does not exist'})

    // Remove action from the database
    action.remove(err => {
      if (err) return res.status(500).send({message: `Error at deleting Action: ${err}`})

      res.status(200).send({message: 'Action has been deleted'})
    })
  })
}

// --------------- Statistics Functions --------------- //

// Retrieve actions sent during a specific month of the year
function getActionsByMonth (req, res) {
  let month = req.params.month
  let year = req.params.year

  Action.find({month: month, year: year}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}

// Retrieve actions sent during a specific month of the year
function getActionsByDay (req, res) {
  let month = req.params.month
  let year = req.params.year
  let day = req.params.day

  Action.find({day: day, month: month, year: year}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}

// Retrieve actions sent during the last 7 days
function getLastWeekActions (req, res) {



  Action.find({day: day, month: month, year: year}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}

// Retrieve actions sent during a specific month of the year
function getDeviceActionsByMonth (req, res) {
  let month = req.params.month
  let year = req.params.year
  let deviceId = req.params.deviceId

  Action.find({deviceId: deviceId, month: month, year: year}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}

// Retrieve actions sent during a specific month of the year
function getDeviceActionsByDay (req, res) {
  let month = req.params.month
  let year = req.params.year
  let day = req.params.day
  let deviceId = req.params.deviceId

  Action.find({deviceId: deviceId, day: day, month: month, year: year}, (err, action) => {
    if (err) return res.status(500).send({message: `Error at processing petition: ${err}`})
    if(!action) return res.status(404).send({message:'There are no actions registered'})

    res.status(200).send({action})
  })
}

module.exports = {
  sendAction,
  getActions,
  getActionsByDeviceId,
  getActionsByType,
  getActionsByRoom,
  deleteAction,
  getActionsByMonth,
  getActionsByDay,
  getLastWeekActions,
  getDeviceActionsByMonth,
  getDeviceActionsByDay
}
