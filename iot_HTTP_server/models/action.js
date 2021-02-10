'use strict'

const mongoose = require('mongoose')
const Schema = mongoose.Schema

const ActionSchema = Schema({
  deviceId: String,
  newState: String,
  room: String,
  deviceType: String,
  year: Number,
  month: Number,
  day: Number,
  hour: Number
})

module.exports = mongoose.model('Action', ActionSchema)
