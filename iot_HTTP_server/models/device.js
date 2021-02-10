'use strict'

const mongoose = require('mongoose')
const Schema = mongoose.Schema

const DeviceSchema = Schema({
  name: String,
  deviceType: String,
  state: String,
  room: String,
  receivingTopic: String,
  respondingTopic: String
})

module.exports = mongoose.model('Device', DeviceSchema)
